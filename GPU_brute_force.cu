#include <iostream>
#include <string>
#include <ctime>
#include <curand.h>
#include <curand_kernel.h>

using namespace std;

const string ALPHABET_SET = "0123456789!@#$%^&*abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

// device utility functions
__device__
int strcmp(char* str1, char* str2, int length);

__device__
void strcpy(char *dest, char *src)
{
    int i = 0;
	do {
		dest[i] = src[i];
	} while (src[++i] != '\0');
}

__device__
int strlen(char *string)
{
    int count = 0;
	while (string[count] != '\0') {
		++count;
	}
	return count;
}

//kernel
__global__
void random_password(char* pass, char* alphabet_set, unsigned int seed)
{

    extern __shared__ char alphabet[];

    char test[10];
    int passLen = strlen(pass);
    int alphabet_length = strlen(alphabet_set);

    for (int i = 0; i<alphabet_length; i++)
        alphabet[i] = alphabet_set[i];

    // int digit[8];
    // digit[0] = blockIdx.x;

    printf("Block ID: %d\n", blockIdx.x);
    printf("Thread ID: %d\n", threadIdx.x);

    // for radom index from alphabet set range
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
void bruteforce()
{
    char pass[] = "caaaaa";
    char alphabet_set[] = "abc";
    int passLen = strlen(pass);
    int alphabet_length = strlen(alphabet_set);


    if (passLen == 1){
        for (int i = 0; i < alphabet_length; i++){
            printf("%c\n",alphabet_set[i]); //call kernel <<<1,1>>
        }
    }
    else if (passLen == 2){
        for (int i = 0; i < alphabet_length; i++){
            printf("%c%c\n",alphabet_set[i], 
                            alphabet_set[threadIdx.x]); //call kernel <<<1,3>>>
        }
    }
    else if (passLen == 3){
        for (int i = 0; i < alphabet_length; i++){
            printf("%c%c%c\n",alphabet_set[i], 
                            alphabet_set[threadIdx.x],
                            alphabet_set[(int)(blockIdx.x % alphabet_length)]);
        }
    }
    else if (passLen == 4){
        for (int i = 0; i < alphabet_length; i++){
            printf("%c%c%c%c\n", alphabet_set[i], 
                                alphabet_set[threadIdx.x], 
                                alphabet_set[(int)(blockIdx.x % alphabet_length)],
                                alphabet_set[(int)((blockIdx.x / alphabet_length ) % alphabet_length)]);
                
        }
    }    
    else if (passLen == 5){
        for (int i = 0; i < alphabet_length; i++){
            printf("%c%c%c%c%c\n", alphabet_set[i], 
                                alphabet_set[threadIdx.x], 
                                alphabet_set[(int)(blockIdx.x % alphabet_length)],
                                alphabet_set[(int)((blockIdx.x / alphabet_length ) % alphabet_length)],
                                alphabet_set[(int)((blockIdx.x / (alphabet_length*alphabet_length)) % alphabet_length)]);
                
        }
    }
    else if (passLen == 6){
        for (int i = 0; i < alphabet_length; i++){
            printf("%c%c%c%c%c%c\n", alphabet_set[i], 
                                alphabet_set[threadIdx.x], 
                                alphabet_set[(int)(blockIdx.x % alphabet_length)],
                                alphabet_set[(int)((blockIdx.x / alphabet_length ) % alphabet_length)],
                                alphabet_set[(int)((blockIdx.x / (alphabet_length*alphabet_length)) % alphabet_length)],
                                alphabet_set[(int)((blockIdx.x / (alphabet_length*alphabet_length*alphabet_length)) % alphabet_length)]);
                
        }
    }
        
    
}

//driver code
int main()
{
    // string pass = "abc";
    // char *d_pass, *d_alphabet;
    // cudaMalloc((void**)&d_pass, sizeof(char)*pass.length() + 1);
    // cudaMalloc((void**)&d_alphabet, sizeof(char)*ALPHABET_SET.length() + 1);
    // cudaMemcpy(d_pass, pass.c_str(), sizeof(char)*pass.length() + 1, cudaMemcpyHostToDevice);
    // cudaMemcpy(d_alphabet, ALPHABET_SET.c_str(), sizeof(char)*ALPHABET_SET.length() + 1, cudaMemcpyHostToDevice);
    // random_password<<<1,1, sizeof(char) * ALPHABET_SET.length()>>>(d_pass, d_alphabet, time(NULL));
    
    // cudaFree(d_alphabet);
    // cudaFree(d_pass);


    bruteforce<<<3*3*3*3*3*3,3>>>();

    return -1;
}