#include <iostream>
#include <string>
#include <iomanip>
#include <ctime>
#include <curand.h>
#include <curand_kernel.h>

using namespace std;

const string ALPHABET_SET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

// device utility functions
__device__
int c_strcmp(char* str1, char* str2, int length)
{
    int flag = 0;

	for (int i = 0; i<length; i++) {
		if (str1[i] != str2[i]) {
			flag = 1;
			break;
		}
	}

	return flag;
}

__device__
void c_strcpy(char *dest, char *src)
{
    int i = 0;
	do {
		dest[i] = src[i];
	} while (src[++i] != '\0');
}

__device__
int c_strlen(char *string)
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
    int passLen = c_strlen(pass);
    int a_l = c_strlen(alphabet_set);

    for (int i = 0; i<a_l; i++)
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
        rand = curand(&state) % a_l;
        test[i] = alphabet[rand];
    }
    test[passLen] ='\0';

    for(int i = 0; i < passLen; i++){
        printf("%c", test[i]);
    }
   
}
__global__
void bruteforce(char* pass, char* alphabet_set, char* generated_pass)
{
    int passLen = c_strlen(pass);
    int a_l = c_strlen(alphabet_set); // Alphabet length
   

    if (passLen == 1){ //call kernel by <<<1,1>>
        for (int i = 0; i < a_l; i++){
            printf("%c\n",alphabet_set[i]); 
        }
    }
    else if (passLen == 2){ //call kernel by <<<1,len>>>
        for (int i = 0; i < a_l; i++){
            printf("%c%c\n",alphabet_set[i], 
                            alphabet_set[threadIdx.x]); 
        }
    }
    else if (passLen == 3){ //call kernel by <<<len,len>>>
        for (int i = 0; i < a_l; i++){
            printf("%c%c%c\n", alphabet_set[i], 
                            alphabet_set[threadIdx.x],
                            alphabet_set[(int)(blockIdx.x % a_l)]);
        }
    }
    else if (passLen == 4){ //call kernel by <<<len^4,len>>>
        for (int i = 0; i < a_l; i++){
            printf("%c%c%c%c\n", alphabet_set[i], 
                                alphabet_set[threadIdx.x], 
                                alphabet_set[(int)(blockIdx.x % a_l)],
                                alphabet_set[(int)((blockIdx.x / a_l ) % a_l)]);
                
        }
    }    
    else if (passLen == 5){ //call kernel by <<<len^5,len>>>
        for (int i = 0; i < a_l; i++){
            printf("%c%c%c%c%c\n", alphabet_set[i], 
                                alphabet_set[threadIdx.x], 
                                alphabet_set[(int)(blockIdx.x % a_l)],
                                alphabet_set[(int)((blockIdx.x / a_l ) % a_l)],
                                alphabet_set[(int)((blockIdx.x / (a_l*a_l)) % a_l)]);
                
        }
    }
    else if (passLen == 6){ //call kernel by <<<len^6,len>>>
        for (int i = 0; i < a_l; i++){
            printf("%c%c%c%c%c%c\n", alphabet_set[i], 
                                alphabet_set[threadIdx.x], 
                                alphabet_set[(int)(blockIdx.x % a_l)],
                                alphabet_set[(int)((blockIdx.x / a_l ) % a_l)],
                                alphabet_set[(int)((blockIdx.x / (a_l*a_l)) % a_l)],
                                alphabet_set[(int)((blockIdx.x / (a_l*a_l*a_l)) % a_l)]);
                
        }
    }
    else if (passLen == 7){ //call kernel by <<<len^7,len>>>
        for (int i = 0; i < a_l; i++){
            printf("%c%c%c%c%c%c%c\n", alphabet_set[i], 
                                alphabet_set[threadIdx.x], 
                                alphabet_set[(int)(blockIdx.x % a_l)],
                                alphabet_set[(int)((blockIdx.x / a_l ) % a_l)],
                                alphabet_set[(int)((blockIdx.x / (a_l*a_l)) % a_l)],
                                alphabet_set[(int)((blockIdx.x / (a_l*a_l*a_l)) % a_l)],
                                alphabet_set[(int)((blockIdx.x / (a_l*a_l*a_l*a_l)) % a_l)]);
                
        }
    }
    else if (passLen == 8){ //call kernel by <<<len^8,len>>>
        for (int i = 0; i < a_l; i++){
            printf("%c%c%c%c%c%c%c%c\n", alphabet_set[i], 
                                alphabet_set[threadIdx.x], 
                                alphabet_set[(int)(blockIdx.x % a_l)],
                                alphabet_set[(int)((blockIdx.x / a_l ) % a_l)],
                                alphabet_set[(int)((blockIdx.x / (a_l*a_l)) % a_l)],
                                alphabet_set[(int)((blockIdx.x / (a_l*a_l*a_l)) % a_l)],
                                alphabet_set[(int)((blockIdx.x / (a_l*a_l*a_l*a_l)) % a_l)],
                                alphabet_set[(int)((blockIdx.x / (a_l*a_l*a_l*a_l*a_l)) % a_l)]);
                
        }
    }
        
    
}



//driver code
int main()
{

    string password;

    cout << "Please enter password to crack: ";
    cin >> password;

    char* d_pass;
    char* d_alphabet_set;
    char* d_generated_pass;
    char* result = (char*)malloc(sizeof(char)*password.length() + 1);

    cudaMalloc((void**)&d_pass, sizeof(char)*password.length() + 1);
    cudaMalloc((void**)&d_alphabet_set, sizeof(char)*ALPHABET_SET.length() + 1);
    cudaMalloc((void**)&d_generated_pass, sizeof(char)*password.length() + 1);
    cudaMemcpy(d_pass, password.c_str(), sizeof(char)*password.length() + 1, cudaMemcpyHostToDevice);
    cudaMemcpy(d_alphabet_set, ALPHABET_SET.c_str(), sizeof(char)*ALPHABET_SET.length() + 1, cudaMemcpyHostToDevice);
    cudaMemcpy(d_generated_pass, result, sizeof(char)*password.length() + 1, cudaMemcpyHostToDevice);

    // while (true)
    // {
        int a_l = ALPHABET_SET.length();
        int p_l = password.length();
             
        bruteforce<<<1,1>>>(d_pass, d_alphabet_set, d_generated_pass);

        cudaMemcpy(result, d_generated_pass, sizeof(char)*password.length() + 1, cudaMemcpyDeviceToHost);

        free(result);

    // }

    return -1;
}