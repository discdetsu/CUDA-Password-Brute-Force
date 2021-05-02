#include <iostream>
#include <string>

using namespace std;

const string ALPHABET_SET = "A-Za-z";

// device utility functions
__device__
int cuda_strcmp(char* str1, char* str2, int length);
__device__
void cuda_strcpy(char *dest, char *src);
__device__
int cuda_strlen(char *string);

//kernel
__global__
void bruteforce();

//driver code
int main()
{
    return -1;
}