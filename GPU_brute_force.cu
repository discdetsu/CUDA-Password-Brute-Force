#include <iostream>
#include <string>
#include <ctime>
#include <curand.h>
#include <curand_kernel.h>

using namespace std;

const string ALPHABET_SET = "0123456789!@#$%^&*abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

// device utility functions
__device__
int cuda_strcmp(char* str1, char* str2, int length);
__device__
void cuda_strcpy(char *dest, char *src);
__device__
int cuda_strlen(char *string)
{
    int count = 0;
	while (string[count] != '\0') {
		++count;
	}
	return count;
}
__device__
bool check(char *pass, char c1, char c2, char c3){

    if (c1 == pass[0] && c2 == pass[1] && c3 == pass[2])
        return true;

    return false;
}

//kernel
__global__
void random_password(char* pass, char* alphabet_set, unsigned int seed)
{

    extern __shared__ char alphabet[];

    char test[10];
    int passLen = cuda_strlen(pass);
    int alphabet_length = cuda_strlen(alphabet_set);

    for (int i = 0; i<alphabet_length; i++)
        alphabet[i] = alphabet_set[i];

    curandState_t state;
    int rand;
    curand_init(seed,0,0,&state);
    

    for(int i = 0; i < passLen; i++){
        rand = curand(&state) % alphabet_length;
        test[i] = alphabet[rand];
    }
    test[passLen] ='\0';

    for(int i = 0; i < passLen; i++){
        printf("%c", test[i]);
    }



}
__global__
void bruteforce(char* pass)
{
    
        printf("Block ID: %d, Thread ID: %d, Block Dimension: %d\n", blockIdx.x, threadIdx.x, blockDim.x);
        printf("Index: %d\n",  threadIdx.x + blockDim.x *  blockIdx.x);
  
        // printf("%c%c%c\n", (char)c1, (char)blockIdx.x, (char)threadIdx.x + 31);
        
    
}

//driver code
int main()
{
    string pass = "abc";
    char *d_pass, *d_alphabet;
    cudaMalloc((void**)&d_pass, sizeof(char)*pass.length() + 1);
    cudaMalloc((void**)&d_alphabet, sizeof(char)*ALPHABET_SET.length() + 1);
    cudaMemcpy(d_pass, pass.c_str(), sizeof(char)*pass.length() + 1, cudaMemcpyHostToDevice);
    cudaMemcpy(d_alphabet, ALPHABET_SET.c_str(), sizeof(char)*ALPHABET_SET.length() + 1, cudaMemcpyHostToDevice);
    random_password<<<1,1, sizeof(char) * ALPHABET_SET.length()>>>(d_pass, d_alphabet, time(NULL));

    cudaFree(d_alphabet);
    cudaFree(d_pass);
    return -1;
}