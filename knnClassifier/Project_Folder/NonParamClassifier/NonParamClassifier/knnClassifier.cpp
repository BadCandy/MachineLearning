#include <vector>
#include <cstdlib>
#include <cstdio>
#include <algorithm>

using std::pair;
using std::vector;
using std::sort;

typedef double _2dMatrix[4][4];
typedef int _2dIMatrix[3][3];
char* class_name[3] = { "Iris-setosa", "Iris-versicolor", "Iris-virginica" };

/*
	Iris Data를 담을 구조체
*/
struct Iris 
{	
	//train-data와 test-data에서 사용
	double x[4];	//특징 벡터
	char w[20];		//부류

	//test-data에서만 사용
	char* s;			//분류 결과
	bool is_right = true;	//분류가 옳게 됬는지
};

/*
	Iris data를 받아들이기 위한 함수
*/
const void Set_Data(Iris data[], const char* file_name)
{
	FILE* file;
	errno_t err;
	err = fopen_s(&file, file_name, "r");
	if (err != 0)
	{
		puts(file_name);
		puts("의 경로에 있는 데이터 입출력에 오류가 있습니다.");
		exit(0);
	}
	for (size_t i = 0; i < 75; i++)
	{
		fscanf_s(file, "%lf, %lf, %lf, %lf,", &data[i].x[0], &data[i].x[1], &data[i].x[2], &data[i].x[3]);
		fscanf_s(file, "%s", data[i].w, sizeof(data[i].w));
	}
	fclose(file);
}

/*
	평균을 구하기 위한 함수
*/
const void Set_Mean(const Iris data[], double mean[]
					, const unsigned startIndex, const unsigned length)
{
	for (size_t i = 0; i < 4; i++)
	{
		double total = 0;
		for (size_t j = startIndex; j < length; j++)
		{
			total += data[j].x[i];
		}
		mean[i] = total / 25;
	}
}

/*
	공분산을 구하기 위한 함수
*/
const void Set_Cov(const Iris data[], const double mean[], _2dMatrix& cov
					, const unsigned startIndex, const unsigned length)
{
	for (size_t k = startIndex; k < length; k++)
	{
		double temp[4] = { data[k].x[0] - mean[0], data[k].x[1] - mean[1], data[k].x[2] - mean[2], data[k].x[3] - mean[3] };
		for (size_t i = 0; i < 4; i++)
		{
			for (size_t j = 0; j < 4; j++)
			{
				cov[i][j] += temp[i] * temp[j];
			}
		}
	}
	for (size_t i = 0; i < 4; i++)
	{
		for (size_t j = 0; j < 4; j++)
		{
			cov[i][j] = cov[i][j] / (25 - 1);
		}
	}
	
	
}

/*
	역행렬을 구하기 위한 함수
*/
const int Inverse_Matrix(const int n, const double* A, double* b)
{
	double m;
	register int i, j, k;
	double* a = new double[n*n];

	if (a == NULL)
		return 0;
	for (i = 0; i<n*n; i++)
		a[i] = A[i];
	for (i = 0; i<n; i++)
	{
		for (j = 0; j<n; j++)
		{
			b[i*n + j] = (i == j) ? 1. : 0.;
		}
	}
	for (i = 0; i<n; i++)
	{
		if (a[i*n + i] == 0.)
		{
			if (i == n - 1)
			{
				delete[] a;
				return 0;
			}
			for (k = 1; i + k<n; k++)
			{
				if (a[i*n + i + k] != 0.)
					break;
			}
			if (i + k >= n)
			{
				delete[] a;
				return 0;
			}
			for (j = 0; j<n; j++)
			{
				m = a[i*n + j];
				a[i*n + j] = a[(i + k)*n + j];
				a[(i + k)*n + j] = m;
				m = b[i*n + j];
				b[i*n + j] = b[(i + k)*n + j];
				b[(i + k)*n + j] = m;
			}
		}
		m = a[i*n + i];
		for (j = 0; j<n; j++)
		{
			a[i*n + j] /= m;
			b[i*n + j] /= m;
		}
		for (j = 0; j<n; j++)
		{
			if (i == j)
				continue;

			m = a[j*n + i];
			for (k = 0; k<n; k++)
			{
				a[j*n + k] -= a[i*n + k] * m;
				b[j*n + k] -= b[i*n + k] * m;
			}
		}
	}
	delete[] a;
	return 1;
}

/*
	1nn-Classifier 동작을 하는 함수
*/
const void _1nn_Classify(Iris test_data[], const _2dMatrix inv_cov[]
						, const double mean[][4])
{
	for (size_t l = 0; l < 75; l++)
	{
		double temp1[3][4];
		for (size_t i = 0; i < 3; i++)
		{
			for (size_t j = 0; j < 4; j++)
			{
				temp1[i][j] = test_data[l].x[j] - mean[i][j];
			}
		}

		double temp2[3][4] = { { 0 } };
		for (size_t i = 0; i < 3; i++)
		{
			for (size_t j = 0; j < 4; j++)
			{
				for (size_t k = 0; k < 4; k++)
				{
					temp2[i][j] += temp1[i][k] * inv_cov[i][k][j];
				}
			}
		}

		double temp3[3] = { 0 };
		double minDistance = DBL_MAX;
		int minIndex = 0;
		for (size_t i = 0; i < 3; i++)
		{
			for (size_t j = 0; j < 4; j++)
			{
				temp3[i] += temp2[i][j] * temp1[i][j];
			}
			if (minDistance > temp3[i])
			{
				minDistance = temp3[i];
				minIndex = i;
			}
		}
		test_data[l].s = class_name[minIndex];
		if (strcmp(test_data[l].w, test_data[l].s) != 0)
			test_data[l].is_right = false;
	}
}

/*
	Knn-Classifier 동작을 하는 함수
*/
const void _Knn_Classify(Iris test_data[], const _2dMatrix inv_cov[]
					, Iris train_data[], const int K)
{
	for (size_t p = 0; p < 75; p++)
	{
		vector< pair < double, char* > > v(75);
		for (size_t l = 0; l < 75; l++)
		{
			_2dMatrix part_inv_cov;
			for (size_t i = 0; i < 3; i++)
			{
				if (strcmp(train_data[l].w, class_name[i]))
				{
					memcpy(part_inv_cov, inv_cov[i], sizeof(double) * 4 * 4);
				}
			}

			double temp1[4];
			for (size_t j = 0; j < 4; j++)
			{
				temp1[j] = test_data[p].x[j] - train_data[l].x[j];
			}


			double temp2[4] = { 0 };
			for (size_t j = 0; j < 4; j++)
			{
				for (size_t k = 0; k < 4; k++)
				{
					temp2[j] += temp1[k] * part_inv_cov[k][j];
				}
			}

			double distance = 0;
			for (size_t j = 0; j < 4; j++)
			{
				distance += temp2[j] * temp1[j];
			}
			v[l].first = distance;
			v[l].second = train_data[l].w;
		}
		sort(v.begin(), v.end());

		vector< pair < int, pair < double, char* > > > v2(3);
		for (size_t q = 0; q < 3; q++)
		{
			v2[q].first = 0;
			v2[q].second.first = 50;
			v2[q].second.second = nullptr;
		}

		for (size_t i = 0; i < K; i++)
		{
			for (size_t j = 0; j < 3; j++)
			{
				if (strcmp(v[i].second, class_name[j]) == 0)
				{
					v2[j].first++;
					v2[j].second.first -= v[i].first;
					v2[j].second.second = v[i].second;
				}
			}
		}
		sort(v2.begin(), v2.end());
		
		for (size_t i = 0; i < 3; i++)
		{
			printf("%d : %lf, %s \n", i, 50 - v2[i].second.first, v2[i].second.second);
		}
		printf("\n");

		test_data[p].s = v2[2].second.second;
		if (strcmp(test_data[p].s, test_data[p].w) != 0)
		{
			test_data[p].is_right = false;
		}
	}
}

struct Report
{
	char* class_name;
	int num_instance;
	int num_success;
	double accuracy;
};

const void Set_Report(Iris test_data[], Report report[])
{
	double total = 25;
	int count = 0;
	for (size_t i = 0; i < 25; i++)
	{
		if (test_data[i].is_right)
			count++;
	}
	report[0].num_success = count;
	report[0].accuracy = count / total * 100;

	count = 0;
	for (size_t i = 25; i < 50; i++)
	{
		if (test_data[i].is_right)
			count++;
	}
	report[1].num_success = count;
	report[1].accuracy = count / total * 100;

	count = 0;
	for (size_t i = 50; i < 75; i++)
	{
		if (test_data[i].is_right)
			count++;
	}
	report[2].num_success = count;
	report[2].accuracy = count / total * 100;

	for (size_t i = 0; i < 3; i++)
	{
		report[i].num_instance = 25;
		report[i].class_name = class_name[i];
	}
}

void Set_ResTable(Iris test_data[], _2dIMatrix res_table)
{
	memset(res_table, 0, sizeof(int)* 3 * 3);
	for (size_t i = 0; i < 75; i++)
	{
		if (strcmp(test_data[i].w, test_data[i].s) == 0)
		{
			for (size_t j = 0; j < 3; j++)
			{
				if (strcmp(test_data[i].w, class_name[j]) == 0)
				{
					res_table[j][j]++;
					break;
				}
			}
		}
		else
		{
			int k;
			int j;
			for (k = 0; k < 3; k++)
			{
				if (strcmp(test_data[i].w, class_name[k]) == 0)
				{
					break;
				}
			}
			for (j = 0; j < 3; j++)
			{
				if (strcmp(test_data[i].s, class_name[j]) == 0)
				{
					break;
				}
			}
			res_table[k][j]++;
		}
	}
}

const void Result_FromDataToFile(const Iris data[], const char* file_name)
{
	FILE* file;
	errno_t err;
	err = fopen_s(&file, file_name, "w");
	if (err != 0)
	{
		puts(file_name);
		puts("의 경로에 있는 데이터 입출력에 오류가 있습니다.");
		exit(0);
	}
	fprintf(file, "IRIS K-NN CLASSIFICATION RESULT \n");
	fprintf(file, "Format: Index, ExpectedClass, OutputClass, IsFail \n \n");
	for (size_t i = 0; i < 75; i++)
	{
		fprintf(file, "%d, %s, %s   %s \n", (i + 1), data[i].w, data[i].s, data[i].is_right ? "" : "fail");
	}
	fclose(file);
}

const void Report_FromDataToFile(const Report report[], const char* file_name)
{
	FILE* file;
	errno_t err;
	err = fopen_s(&file, file_name, "w");
	if (err != 0)
	{
		puts(file_name);
		puts("의 경로에 있는 데이터 입출력에 오류가 있습니다.");
		exit(0);
	}
	fprintf(file, "IRIS K-NN CLASSIFICATION REPORT \n");
	fprintf(file, "Data UCI \n");
	fprintf(file, "Format: Index, ClassName, NumOfInstance, NumOfSuccess, Accuracy \n \n");
	int count = 0;
	for (size_t i = 0; i < 3; i++)
	{
		count += report[i].num_success;
		fprintf(file, "%d, %s, %d, %d, %.2lf%% \n", (i + 1), report[i].class_name, report[i].num_instance, report[i].num_success, report[i].accuracy);
	}
	double accuracy = count / 75.0 * 100;
	fprintf(file, "\n \nNumOfTotal : 75, NumOfTotalSuccess : %d, TotalAccuracy : %.2lf%%", count, accuracy);
	fclose(file);
}

const void ResTable_FromDataToFile(const _2dIMatrix res_table, const char* file_name)
{
	FILE* file;
	errno_t err;
	err = fopen_s(&file, file_name, "w");
	if (err != 0)
	{
		puts(file_name);
		puts("의 경로에 있는 데이터 입출력에 오류가 있습니다.");
		exit(0);
	}
	fprintf(file, "IRIS K-NN CLASSIFICATION RESTABLE \n");
	fprintf(file, "Format(Horizontal) : Iris-setosa, Iris-versicolor, Iris-virginica \n");
	fprintf(file, "Format(Vertical) : Iris-setosa, Iris-versicolor, Iris-virginica \n\n");
	for (size_t i = 0; i < 3; i++)
	{
		for (size_t j = 0; j < 3; j++)
		{
			fprintf(file, "%d ", res_table[i][j]);
		}
		fprintf(file, "\n");
	}


	fclose(file);
}

const void Show_Matrix(const _2dMatrix& matrix, int row, int col)
{
	for (size_t i = 0; i < row; i++)
	{
		for (size_t j = 0; j < col; j++)
		{
			printf("%lf ", matrix[i][j]);
		}
		printf("\n");
	}
	printf("\n");
}

const void Show_Matrix(const double matrix[], int row)
{
	for (size_t i = 0; i < row; i++)
	{
		printf("%lf ", matrix[i]);
	}
	printf("\n");
}

const void Show_TestData(const Iris data[])
{
	for (size_t i = 0; i < 75; i++)
	{
		printf("%d, %s, %s, %s \n", (i + 1), data[i].w, data[i].s, data[i].is_right ? "true" : "false");
	}
}

const void Show_TrainData(const Iris data[])
{
	for (size_t i = 0; i < 75; i++)
	{
		printf("%d, %s, %s, %s \n", (i + 1), data[i].w, data[i].s, data[i].is_right ? "true" : "false");
	}
}

Iris train_data[75];
Iris _1nn_testData[75];
Iris _3nn_testData[75];
Iris _5nn_testData[75];
Iris _7nn_testData[75];

_2dMatrix cov[3];
_2dMatrix inv_cov[3];
double mean[3][4];

Report _1nn_report[3];
Report _3nn_report[3];
Report _5nn_report[3];
Report _7nn_report[3];

_2dIMatrix _1nn_res_table;
_2dIMatrix _3nn_res_table;
_2dIMatrix _5nn_res_table;
_2dIMatrix _7nn_res_table;

int main()
{
	//훈련용 데이터를 set한다.
	Set_Data(train_data, "rsc\\iris_training.data");
	Set_Mean(train_data, mean[0], 0, 25);
	Set_Mean(train_data, mean[1], 25, 50);
	Set_Mean(train_data, mean[2], 50, 75);
	Set_Cov(train_data, mean[0], cov[0], 0, 25);
	Set_Cov(train_data, mean[1], cov[1], 25, 50);
	Set_Cov(train_data, mean[2], cov[2], 50, 75);
	Inverse_Matrix(4, (double*)cov[0], (double*)inv_cov[0]);
	Inverse_Matrix(4, (double*)cov[1], (double*)inv_cov[1]);
	Inverse_Matrix(4, (double*)cov[2], (double*)inv_cov[2]);
	
	
	printf("u1의 전치행렬 : \n");
	Show_Matrix(mean[0], 4);
	printf("u2의 전치행렬 : \n");
	Show_Matrix(mean[1], 4);
	printf("u3의 전치행렬 : \n");
	Show_Matrix(mean[2], 4);

	printf("\ncov1 : \n");
	Show_Matrix(cov[0], 4, 4);
	printf("cov2 : \n");
	Show_Matrix(cov[1], 4, 4);
	printf("cov3 : \n");
	Show_Matrix(cov[2], 4, 4);
	

	//테스트 데이터를 set한다.
	Set_Data(_1nn_testData, "rsc\\iris_testing.data");
	//1NN-Classifier 시작
	_1nn_Classify(_1nn_testData, inv_cov, mean);
	Result_FromDataToFile(_1nn_testData, "rsc\\1nn_result.txt");
	Set_Report(_1nn_testData, _1nn_report);
	Report_FromDataToFile(_1nn_report, "rsc\\1nn_report.txt");
	Set_ResTable(_1nn_testData, _1nn_res_table);
	ResTable_FromDataToFile(_1nn_res_table, "rsc\\1nn_resTable.txt");
//	Show_TestData(_1nn_testData);
	

	Set_Data(_3nn_testData, "rsc\\iris_testing.data");
	//3nn-Classifier 시작
	_Knn_Classify(_3nn_testData, inv_cov, train_data, 3);
	Result_FromDataToFile(_3nn_testData, "rsc\\3nn_result.txt");
	Set_Report(_3nn_testData, _3nn_report);
	Report_FromDataToFile(_3nn_report, "rsc\\3nn_report.txt");
	Set_ResTable(_3nn_testData, _3nn_res_table);
	ResTable_FromDataToFile(_3nn_res_table, "rsc\\3nn_resTable.txt");
//	Show_TestData(_3nn_testData);

	Set_Data(_5nn_testData, "rsc\\iris_testing.data");
	//5nn-Classifier 시작
	_Knn_Classify(_5nn_testData, inv_cov, train_data, 5);
	Result_FromDataToFile(_5nn_testData, "rsc\\5nn_result.txt");
	Set_Report(_5nn_testData, _5nn_report);
	Report_FromDataToFile(_5nn_report, "rsc\\5nn_report.txt");
	Set_ResTable(_5nn_testData, _5nn_res_table);
	ResTable_FromDataToFile(_5nn_res_table, "rsc\\5nn_resTable.txt");
//	Show_TestData(_5nn_testData);

	Set_Data(_7nn_testData, "rsc\\iris_testing.data");
	//7nn-Classifier 시작
	_Knn_Classify(_7nn_testData, inv_cov, train_data, 7);
	Result_FromDataToFile(_7nn_testData, "rsc\\7nn_result.txt");
	Set_Report(_7nn_testData, _7nn_report);
	Report_FromDataToFile(_7nn_report, "rsc\\7nn_report.txt");
	Set_ResTable(_7nn_testData, _7nn_res_table);
	ResTable_FromDataToFile(_7nn_res_table, "rsc\\7nn_resTable.txt");
//	Show_TestData(_7nn_testData);

	return 0;
}