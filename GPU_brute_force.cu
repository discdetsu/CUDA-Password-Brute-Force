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
int c_strlen(char *string)
{
    int count = 0;
	while (string[count] != '\0') {
		++count;
	}
	return count;
}

//kernel
// __global__
// void random_password(char* pass, char* alphabet_set, unsigned int seed)
// {

//     extern __shared__ char alphabet[];

//     char test[10];
//     int passLen = c_strlen(pass);
//     int a_l = c_strlen(alphabet_set);

//     for (int i = 0; i<a_l; i++)
//         alphabet[i] = alphabet_set[i];

//     // int digit[8];
//     // digit[0] = blockIdx.x;

//     printf("Block ID: %d\n", blockIdx.x);
//     printf("Thread ID: %d\n", threadIdx.x);

//     // for radom index from alphabet set range
//     curandState_t state;
//     int rand;
//     curand_init(seed,0,0,&state);

//     for(int i = 0; i < passLen; i++){
//         rand = curand(&state) % a_l;
//         test[i] = alphabet[rand];
//     }
//     test[passLen] ='\0';

//     for(int i = 0; i < passLen; i++){
//         printf("%c", test[i]);
//     }
   
// }




__global__
void bruteforce(char* pass, char* alphabet_set)
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
    else if (passLen == 4){ //call kernel by <<<len^2,len>>>
        for (int i = 0; i < a_l; i++){
            printf("%c%c%c%c\n", alphabet_set[i], 
                                alphabet_set[threadIdx.x], 
                                alphabet_set[(int)(blockIdx.x % a_l)],
                                alphabet_set[(int)((blockIdx.x / a_l ) % a_l)]);
                
        }
    }    
    else if (passLen == 5){ //call kernel by <<<len^3,len>>>
        for (int i = 0; i < a_l; i++){
            printf("%c%c%c%c%c\n", alphabet_set[i], 
                                alphabet_set[threadIdx.x], 
                                alphabet_set[(int)(blockIdx.x % a_l)],
                                alphabet_set[(int)((blockIdx.x / a_l ) % a_l)],
                                alphabet_set[(int)((blockIdx.x / (a_l*a_l)) % a_l)]);
                
        }
    }
    else if (passLen == 6){ //call kernel by <<<len^4,len>>>
        for (int i = 0; i < a_l; i++){
            printf("%c%c%c%c%c%c\n", alphabet_set[i], 
                                alphabet_set[threadIdx.x], 
                                alphabet_set[(int)(blockIdx.x % a_l)],
                                alphabet_set[(int)((blockIdx.x / a_l ) % a_l)],
                                alphabet_set[(int)((blockIdx.x / (a_l*a_l)) % a_l)],
                                alphabet_set[(int)((blockIdx.x / (a_l*a_l*a_l)) % a_l)]);
                
        }
    }
    else if (passLen == 7){ //call kernel by <<<len^5,len>>>
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
    else if (passLen == 8){ //call kernel by <<<len^6,len>>>
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

    cudaEvent_t start, stop; //timer
    float ms;
    cudaEventCreate(&start);
	cudaEventCreate(&stop);

    string password;

    cout << "Please enter password: ";
    cin >> password;

    char* d_pass;
    char* d_alphabet_set;

    cudaMalloc((void**)&d_pass, sizeof(char)*password.length() + 1);
    cudaMalloc((void**)&d_alphabet_set, sizeof(char)*ALPHABET_SET.length() + 1);
   
    cudaMemcpy(d_pass, password.c_str(), sizeof(char)*password.length() + 1, cudaMemcpyHostToDevice);
    cudaMemcpy(d_alphabet_set, ALPHABET_SET.c_str(), sizeof(char)*ALPHABET_SET.length() + 1, cudaMemcpyHostToDevice);
   


    int blocksPerGrid;
    int threadsPerBlock;
    if (password.length() == 1){
        blocksPerGrid = 1;
        threadsPerBlock = 1;
    }
    else if (password.length() == 2){
        threadsPerBlock = ALPHABET_SET.length();
        blocksPerGrid = 1;
    }
    else if (password.length() == 3){
        threadsPerBlock = ALPHABET_SET.length();
        blocksPerGrid = ALPHABET_SET.length();
    }
    else {
        threadsPerBlock = ALPHABET_SET.length();
        blocksPerGrid = (int)std::pow((float)ALPHABET_SET.length(), password.length() - 2);
    }

    cout << blocksPerGrid << endl;

    cudaEventRecord(start);
    bruteforce<<<blocksPerGrid,threadsPerBlock>>>(d_pass, d_alphabet_set);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&ms, start, stop);
    cout << "All combination with password length: " << password.length() << " in: " << ms << " milliseconds." << endl;

    return -1;
}