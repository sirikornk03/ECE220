#include <stdio.h>
#include <inttypes.h>

int32_t print_stamps(int32_t amount, int32_t s1, int32_t s2, int32_t s3, int32_t s4) {
    /*best_value, best_stamp, and best_remaining is initialized to the maximum
    best_s1, best_s2, best_s3, and best_s4 are initial at 0 */
    int32_t best_value = INT32_MAX;       
    int32_t best_stamp = INT32_MAX;
    int32_t best_remaining = INT32_MAX;                      
    int32_t best_s1 = 0, best_s2 = 0, best_s3 = 0, best_s4 = 0;         
   
   /*start counting i(s1), j(s2), k(s3), and l(s4) to get the number of stamp*/
    for (int32_t i = 0; i <= amount / s1; i++) {
        for (int32_t j = 0; j <= amount / s2; j++) {
            for (int32_t k = 0; k <= amount / s3; k++) {

                //calculate the remaining
                int32_t remaining = amount - (i * s1 + j * s2 + k * s3);

                /*if there is no remainder (match), recheck that i,j, and k are positive.
                Then, find l and the total value*/
                if (((remaining%s4 == 0))&&(i>=0)&&(j>=0)&&(k>=0)) {
                    int32_t l = remaining/s4;
                    int32_t total_value = (i * s1) + (j * s2) + (k * s3) + (l * s4);

                    /*make sure that the total value is more than or equal to amount 
                    AND total value is less than or equal to best value AND l is positive*/
                    if ((total_value >= amount) && (total_value <= best_value)&&(l>=0)) {

                        /*find the total number of stamp. After that, check the minimum 
                        number of stamp being used and update best value, stamps, s1, s2, s3, and s4.
                        However, if the total stamp is equal to best stamp, give the highest 
                        number and respectively. */
                        int32_t total_stamps = i + j + k + l;
                        if((total_stamps < best_stamp) || ((total_stamps == best_stamp) && (i > best_s1 || (i == best_s1 && (j > best_s2 || (j == best_s2 && (k > best_s3))))))) {
                            best_value = total_value;
                            best_stamp = total_stamps;
                            best_s1 = i;
                            best_s2 = j;
                            best_s3 = k;
                            best_s4 = l;
                        }
                    }
                }
                /*if there is a remainder (not match), recheck that i,j, and k are positive.
                Then, find l and the total value*/
                else if ((remaining%s4 > 0)||(remaining%s4 < 0))  {
                    //calculate l and total value
                    int32_t l = ((remaining / s4)+1);
                    int32_t total_value = (i * s1) + (j * s2) + (k * s3) + (l * s4);

                    /*make sure that the total value is more than the amount 
                    AND total value is less than or equal to best value AND l is positive*/
                    if (((total_value > amount) && (total_value <= best_value)) && (l>=0)) {

                        /*find the total number of stamp and total remaining. After that, check the minimum 
                        total remaining and number of stamp being used and update best value, stamps, 
                        remaining s1, s2, s3, and s4. However, if the total stamp is equal to best stamp, give the highest 
                        number and respectively. */
                        int32_t total_stamps = i + j + k + l;
                        int32_t total_remaining = total_value - amount;
                        if((total_remaining <= best_remaining) && ((total_stamps < best_stamp) || ((total_stamps == best_stamp) && (i > best_s1 || (i == best_s1 && (j > best_s2 || (j == best_s2 && (k > best_s3)))))))) {
                            best_value = total_value;
                            best_remaining = total_remaining;
                            best_stamp = total_stamps;
                            best_s1 = i;
                            best_s2 = j;
                            best_s3 = k;
                            best_s4 = l;
                        }
                    }
                }
        
            }
        }
    }
    /*print the answer*/
    printf("%d %d %d %d -> %d\n", best_s1, best_s2, best_s3, best_s4, best_value);

    /*program finished successfully*/
    if (best_value == amount) {
        return 1;
    } else {
        return 0;
    }
}