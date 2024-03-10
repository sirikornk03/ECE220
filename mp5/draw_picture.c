/*									tab:8
 *
 * main.c - skeleton source file for ECE220 picture drawing program
 *
 * "Copyright (c) 2018 by Charles H. Zega, and Saransh Sinha."
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice and the following
 * two paragraphs appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE AUTHOR OR THE UNIVERSITY OF ILLINOIS BE LIABLE TO 
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL 
 * DAMAGES ARISING OUT  OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, 
 * EVEN IF THE AUTHOR AND/OR THE UNIVERSITY OF ILLINOIS HAS BEEN ADVISED 
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE AUTHOR AND THE UNIVERSITY OF ILLINOIS SPECIFICALLY DISCLAIM ANY 
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE 
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND NEITHER THE AUTHOR NOR
 * THE UNIVERSITY OF ILLINOIS HAS ANY OBLIGATION TO PROVIDE MAINTENANCE, 
 * SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Author:	    Charles Zega, Saransh Sinha
 * Version:	    1
 * Creation Date:   12 February 2018
 * Filename:	    mp5.h
 * History:
 *	CZ	1	12 February 2018
 *		First written.
 */
#include "mp5.h"

/*
	You must write all your code only in this file, for all the functions!
*/

/*sign function using in near_horizonal, near_vertical, and draw_picture function*/
int32_t sgn (int32_t level2, int32_t level1){
	if (level2 > level1){
        return 1;
    } else if ( level2 < level1){
        return -1;
    } else {
        return 0;
    }
}

/* 
 *  near_horizontal
 *	 
 *	 
 *	
 *	
 * INPUTS: x_start,y_start -- the coordinates of the pixel at one end of the line
 * 	   x_end, y_end    -- the coordinates of the pixel at the other end
 * OUTPUTS: draws a pixel to all points in between the two given pixels including
 *          the end points
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */

int32_t
near_horizontal(int32_t x_start, int32_t y_start, int32_t x_end, int32_t y_end){
    /* Your code goes here! */
	//check
    if (x_start < 0 || x_start >= WIDTH || y_start < 0 || y_start >= HEIGHT || x_end < 0 || x_end >= WIDTH || y_end < 0 || y_end >= HEIGHT){
	return 0;
    }

    //find the appropriate direction to draw the line
    int32_t x1, y1, x2, y2;
    if (x_start < x_end) {
        x1 = x_start;
        y1 = y_start;
        x2 = x_end;
        y2 = y_end;
    } else {
        x1 = x_end;
        y1 = y_end;
        x2 = x_start;
        y2 = y_start;
    }

	//calculate the line by using the provided formula 
    for (int32_t x = x1; x < x2; x++) {
        int32_t y = ((2 * (y2 - y1) * (x - x1) + (x2-x1) * sgn(y2, y1) ) / (2 * (x2-x1))) + y1;
        int32_t result = draw_dot(x, y);
        if (result == 0) {
            return 0; //out of bounds
        }
    }

    return 1; //Success
    
}


/* 
 *  near_vertical
 *	 
 *	 
 *	
 *	
 * INPUTS: x_start,y_start -- the coordinates of the pixel at one end of the line
 * 	   x_end, y_end    -- the coordinates of the pixel at the other end
 * OUTPUTS: draws a pixel to all points in between the two given pixels including
 *          the end points
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */

int32_t
near_vertical(int32_t x_start, int32_t y_start, int32_t x_end, int32_t y_end){
	/* Your code goes here! */
	if (x_start == x_end && y_start == y_end) {
		return draw_dot (x_start, y_start);
	}

	//find the appropriate direction to draw the line
	int32_t x1, y1, x2, y2;
	if (y_start <=y_end){
		x1 = x_start;
		y1 = y_start;
		x2 = x_end;
		y2 = y_end;
	} else{
		x1 = x_end;
		y1 = y_end;
		x2 = x_start;
		y2 = y_start;
	}

	//calculate the line by using the provided formula 
    for (int32_t y = y1; y < y2; y++) {
        int32_t x = ((2 * (x2 - x1) * (y - y1) + (x2-x1) * sgn(y2, y1) ) / (2 * (y2-y1))) + x1;
        int32_t result = draw_dot(x, y);
        if (result == 0) {
            return 0; //out of bounds
        }
    }

    return 1; // Success
	
}

/* 
 *  draw_line
 *	 
 *	 
 *	
 *	
 * INPUTS: x_start,y_start -- the coordinates of the pixel at one end of the line
 * 	   x_end, y_end    -- the coordinates of the pixel at the other end
 * OUTPUTS: draws a pixel to all points in between the two given pixels including
 *          the end points
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */

int32_t
draw_line(int32_t x_start, int32_t y_start, int32_t x_end, int32_t y_end){
	/* Your code goes here! */
	//check
	//find the difference of x and y
	int32_t dx = x_end - x_start;
	int32_t dy = y_end - y_start;

	//dx = 0 go to near_vertical
	if (dx == 0){
		return near_vertical ( x_start, y_start, x_end, y_end);
	}

	/*slope between -1 and 1 -> near_horizontal
	slope larger than 1 or smaller than -1 -> near_vertical*/

	float slope = dy/dx;

	if (slope <= -1 || slope >= 1){
		return near_vertical (x_start, y_start, x_end, y_end);
	} else if (slope >=-1 && slope <=1){
		return near_horizontal (x_start, y_start, x_end, y_end);
	}

	return 0;
}


/* 
 *  draw_rect
 *	 
 *	 
 *	
 *	
 * INPUTS: x,y -- the coordinates of the of the top-left pixel of the rectangle
 *         w,h -- the width and height, respectively, of the rectangle
 * OUTPUTS: draws a pixel to every point of the edges of the rectangle
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */

int32_t
draw_rect(int32_t x, int32_t y, int32_t w, int32_t h){
	/* Your code goes here! */
	//check
	if ( w < 0 || h < 0 ){
		return 0;
	}
	
	//find x2 and y2 by adding w and h, respectively
	int32_t x2 = x + w;
	int32_t y2 = y + h;
	
	int32_t result = 1;

	result &= draw_line(x,y,x2,y);
	result &= draw_line(x,y2,x2,y2);
	result &= draw_line(x,y,x,y2);
	result &= draw_line(x2,y,x2,y2);

	return result; //success
}


/* 
 *  draw_triangle
 *	 
 *	 
 *	
 *	
 * INPUTS: x_A,y_A -- the coordinates of one of the vertices of the triangle
 *         x_B,y_B -- the coordinates of another of the vertices of the triangle
 *         x_C,y_C -- the coordinates of the final of the vertices of the triangle
 * OUTPUTS: draws a pixel to every point of the edges of the triangle
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */
int32_t
draw_triangle(int32_t x_A, int32_t y_A, int32_t x_B, int32_t y_B, int32_t x_C, int32_t y_C){
	/* Your code goes here! */
	int32_t result = 1;
	result = draw_line(x_A,y_A,x_B,y_B);
	result = draw_line(x_B,y_B,x_C,y_C);
	result = draw_line(x_C,y_C,x_A,y_A);

	return result;//success
}

/* 
 *  draw_parallelogram
 *	 
 *	 
 *	
 *	
 * INPUTS: x_A,y_A -- the coordinates of one of the vertices of the parallelogram
 *         x_B,y_B -- the coordinates of another of the vertices of the parallelogram
 *         x_C,y_C -- the coordinates of another of the vertices of the parallelogram
 * OUTPUTS: draws a pixel to every point of the edges of the parallelogram
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */
int32_t
draw_parallelogram(int32_t x_A, int32_t y_A, int32_t x_B, int32_t y_B, int32_t x_C, int32_t y_C){
	/* Your code goes here! */
	int32_t x_D = x_C - (x_B - x_A);
	int32_t y_D = y_C - (y_B - y_A);

	int32_t result = 1;
	result = draw_line(x_A, y_A, x_B, y_B);
	result = draw_line(x_B, y_B, x_C, y_C);
	result = draw_line(x_C, y_C, x_D, y_D);
	result = draw_line(x_D, y_D, x_A, y_A);

	return result; //success
}


/* 
 *  draw_circle
 *	 
 *	 
 *	
 *	
 * INPUTS: x,y -- the center of the circle
 *         inner_r,outer_r -- the inner and outer radius of the circle
 * OUTPUTS: draws a pixel to every point whose distance from the center is
 * 	    greater than or equal to inner_r and less than or equal to outer_r
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */

int32_t
draw_circle(int32_t x, int32_t y, int32_t inner_r, int32_t outer_r){
	/* Your code goes here!*/
	// Verify constraints
    if (inner_r < 0 || outer_r < inner_r) {
        return 0; // invalid radius values
    }
	
	//draw circle
    for (int32_t i = 0; i <= outer_r; ++i) {
        for (int32_t j = 0; j <= outer_r; ++j) {
            int32_t distance = (i * i) + (j * j);
            if (distance <= (outer_r * outer_r) && distance >= (inner_r * inner_r)) {
                draw_dot(x + j, y + i);
				draw_dot(x - j, y + i);
				draw_dot(x + j, y - i);
				draw_dot(x - j, y - i);
            }
        }
    }

    return 1; // success
}
    

/* 
 *  rect_gradient
 *	 
 *	 
 *	
 *	
 * INPUTS: x,y -- the coordinates of the of the top-left pixel of the rectangle
 *         w,h -- the width and height, respectively, of the rectangle
 *         start_color -- the color of the far left side of the rectangle
 *         end_color -- the color of the far right side of the rectangle
 * OUTPUTS: fills every pixel within the bounds of the rectangle with a color
 *	    based on its position within the rectangle and the difference in
 *          color between start_color and end_color
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */

int32_t
rect_gradient(int32_t x, int32_t y, int32_t w, int32_t h, int32_t start_color, int32_t end_color){
		/* Your code goes here! */
		//check
		if (h < 0 || w < 1) {
        	return 0; // invalid height or width
    	}
		
    	//find the intensities of the start 3 color channels
    	int32_t start_red = (start_color >> 16) & 0xFF;
    	int32_t start_green = (start_color >> 8) & 0xFF;
    	int32_t start_blue = start_color & 0xFF;

    	//find the intensities of the end 3 color channels
    	int32_t end_red = (end_color >> 16) & 0xFF;
    	int32_t end_green = (end_color >> 8) & 0xFF;
    	int32_t end_blue = end_color & 0xFF;

		//find x2 and x1
    	int32_t x2 = x + w;
   	 	int32_t x1 = x;

		/*calculate the level for each color levels 
		find the color value for the pixel red (23-16), green (15-8), blue (7-0)*/
    	for (int32_t j = y; j < y + h; ++j) {
        	for (int32_t i = x; i < x + w; ++i) {
            	int32_t level_red = (((2 * (i - x1) * (end_red - start_red) + (x2 - x1) * sgn(end_red, start_red)) / (2 * (x2 - x1))) + start_red);
            	int32_t level_green = (((2 * (i - x1) * (end_green - start_green) + (x2 - x1) * sgn(end_green, start_green)) / (2 * (x2 - x1))) + start_green);
            	int32_t level_blue = (((2 * (i - x1) * (end_blue - start_blue) + (x2 - x1) * sgn(end_blue, start_blue)) / (2 * (x2 - x1))) + start_blue);

            	
            	int32_t color = (level_red << 16) | (level_green << 8) | level_blue;

            	/*use set color and draw a dot function 
				at the pixel location with the calculated color*/
            	set_color(color);
            	draw_dot(i, j);
        	}
    	}
		return 1; //success
	}


/* 
 *  draw_picture
 *	 
 *	 
 *	
 *	
 * INPUTS: none
 * OUTPUTS: alters the image by calling any of the other functions in the file
 * RETURN VALUE: 0 if any of the pixels drawn are out of bounds, otherwise 1
 * SIDE EFFECTS: none
 */


int32_t
draw_picture(){
		/* Your code goes here! */
		//set background
		int32_t xst_background = 0;
		int32_t yst_background = 0;
		int32_t xw = 624;
		int32_t yh = 320;
		int32_t i,j;
	
		draw_rect (xst_background, yst_background, xw, yh);
		for (j = yst_background; j < yh; j++){
			for (i = xst_background; i < xw; i++){
			draw_dot(i,j);
			set_color(0x948fde); //fill rectangle with purple color
			}
		}

		//draw crescent moon shape and set the shadow
		int32_t x = 312, y = 160;
		int32_t moon_radius = 150;
	
		set_color(0xFDEFB2);
		draw_circle(x, y, 0, moon_radius);
		rect_gradient(100, 10, 100, 300, 0xC8A951, 0xFDEFB2);
		rect_gradient(250, 10, 100, 300, 0xFDEFB2, 0xC8A951);
		//rect_gradient(220, 10, 250, 300, 0xFDEFB2,0xC8A951);
	
		set_color(0x948fde);
		draw_circle(x, y, moon_radius, 350);

		int32_t x1 = 360;
		int32_t small_radius = 110;
		set_color(0x948fde);
		draw_circle(x1, y, 0, small_radius);


		//draw cat's face
		int32_t catx_l = 350, caty_l = 150, catf_r = 30;
		set_color(0x0000);
		draw_circle(catx_l, caty_l, 0, catf_r);

		//draw cat's body
		int32_t bodyx = 320, bodyy = 230, bodyx1 = 380, bodyy1 = 230, y1, x2, y2;
		draw_triangle (catx_l, caty_l, bodyx, bodyy, bodyx1, bodyy1);

		for (int i1 =0; i1<60; i1++){
			x1 = 320+i1;
			y1 = 230;
			y2 = 150+(i1/10);
			x2 = ((2 * (380 - 350) * (y2 - 150) + (380-350)) / (2 * (230-150))) + 350;
			draw_line(x1, y1, x2, y2);
		}

		//cat's bottom
		int32_t bottomx =350, bottomy = 240, bottomr = 35;
		set_color (0x0000);
		draw_circle(bottomx, bottomy, 0, bottomr);

		//cat's ears
		int32_t earax_l = 320, earay_l = 110, earbx_l = 320, earby_l = 145, earcx_l = 350, earcy_l = 135;
		draw_triangle(earax_l, earay_l, earbx_l, earby_l, earcx_l, earcy_l);
	
		for (int i2 =0; i2<30; i2++){
			x1 = 320+i2;
			y1 = 145;
			y2 = 110+(i2/15);
			x2 = ((2 * (350 - 320) * (y2 - 110) + (350-320)) / (2 * (135-110))) + 320;
			draw_line(x1, y1, x2, y2);
		}

		int32_t earax_r = 380, earay_r = 110, earbx_r = 380, earby_r = 148, earcx_r = 350, earcy_r = 135;
		draw_triangle(earax_r, earay_r, earbx_r, earby_r, earcx_r, earcy_r);

		for (int i3 = 30; i3>0; i3--){
			x1 = 380-i3;
			y1 = 148;
			y2 = 110+(i3/40);
			x2 = ((2 * (350 - 380) * (y2 - 110) + (350-380)) / (2 * (135-148))) + 380;
			draw_line(x1, y1, x2, y2);
		}

		//cat's tail
		int32_t tail1x = 345, tail1y = 270, tail1w = 10, tail1h =30;
		int32_t l, k;

		draw_rect(tail1x, tail1y, tail1w, tail1h);
		for (k = tail1y; k < tail1h+tail1y; k++){
			for (l = tail1x; l < tail1w+tail1x; l++){
			draw_dot(l,k);
			set_color(0x0000); //fill rectangle with purple color
			}
		}
		draw_line(355, 300, 365, 310);
		draw_line(348, 305, 360, 315);
		int32_t l1 = 305, l2=360, l3=315;
		for (int32_t l = 348; l<355; l++){
			l1 = l1 - 1;
			l2 = l2 + 1;
			l3 = l3 - 1;
			draw_line(l ,l1, l2, l3);
		}
		draw_circle(355, 305, 0,5);
		draw_circle(350, 300, 0, 5);
		draw_circle(361, 309, 0,5);

		//cat's whiskers
		draw_line(330, 150, 300, 150);
		draw_line(335, 145, 305, 140);
		draw_line(335, 155, 310, 160);

		draw_line(380, 150, 400, 150);
		draw_line(375, 145, 395, 140);
		draw_line(375, 155, 393, 160);

	return 1;
	}