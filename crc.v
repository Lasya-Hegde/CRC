`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2025 05:36:26
// Design Name: 
// Module Name: crc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// n is the number of bits od D+r
// m is the number of bits of G
module crc #(parameter m=5,n=14)(
    input clk,                   
    input reset,                 
    input start,                 
    input [n-1:0] data_in, 
    input [m-1:0] G,         
    output reg error,    
    output reg done    ,
    output wire [1:0] new          
    );   
localparam [2:0] s0  = 3'b000,   
                 s1  = 3'b001,   
                 s2  = 3'b010,   
                 s3  = 3'b011,
                 s4  = 3'b100,
                 s5  = 3'b101,
                 s6  = 3'b110;   

reg [2:0] current_state, next_state;
reg [m:0] x_cur, x_next;
reg [(n-m-1):0] y_cur, y_next;
reg [n-1:0] R_cur, R_next;
reg [(n-m):0] count_cur, count_next;



assign new = { done,error};
always @(posedge clk)
begin
    if(reset)
    begin
        current_state<=s0;
        x_cur<=x_next;
        y_cur<=y_next;
        R_cur<=0;
        count_cur<=0;
    end
    else 
    begin
        current_state<=next_state;
        x_cur<=x_next;
        y_cur<=y_next;
        R_cur<=R_next;
        count_cur<=count_next;
    end
end

always @*
begin
    case (current_state)
            s0: begin
                    if(start)
                    begin
                        if(data_in[(n-1)-:1]==0)
                        begin
                            next_state=s1;
                            count_next=count_cur;
                            error=0;
                            R_next=R_cur;
                            x_next={1'b0,data_in[ (n-2) -: (m-1)],1'b0};
                            y_next={data_in[(n-m-2):0],1'b0};
                            done=0;
                        end
                        else
                        begin
                            next_state=s1;
                            count_next=count_cur;
                            error=0;
                            R_next=R_cur;
                            x_next={1'b0,data_in[ (n-1) -: m]};
                            y_next=data_in[(n-m-1):0];
                            done=0;
                        end
                    end
                    else
                    begin
                        error=0;
                        count_next=0;
                        next_state=s0;
                        R_next=R_cur;
                        x_next=x_cur;
                        y_next=y_cur;
                        done=0;
                    end
                end
            s1:begin
                 error=0;
                 R_next=R_cur;
                 x_next=x_cur;
                 y_next=y_cur;
                 done=0;
                 if(count_cur<(n-m+1))
                 begin
                    next_state=s2;
                    count_next=count_cur+1;
                 end
                 else
                 begin
                    next_state=s3;
                    count_next=count_cur;
                 end
                 
               end
               
            s2:begin
                 error=0;
                 R_next=R_cur;
                 x_next=x_cur;
                 y_next=y_cur;
                 count_next=count_cur;
                 done=0;
                 if(count_cur==1)
                 begin
                    next_state=s4;
                 end
                 else
                 begin
                    if(x_cur>=G)
                    begin
                        next_state=s4;
                    end
                    else
                    begin
                        next_state=s5;
                    end
                 end
                 
               end
               
            s3:begin
                 next_state=s0;
                 count_next=0;
                 R_next=R_cur;
                 x_next=x_cur;
                 y_next=y_cur;
                 done=1;
                 if(R_cur==0)
                 begin
                    error=0;
                 end
                 else
                 begin
                    error=1;
                 end
               end
               
            s4:begin
                 error=0;
                 count_next=count_cur;
                 R_next = ( G ^ x_cur)<<1;
                 next_state=s6;
                 x_next=x_cur;
                 y_next=y_cur;
                 done=0;
               end
               
            s5:begin
                 error=0;
                 count_next=count_cur;
                 R_next=x_cur<<1;
                 next_state=s6;
                 x_next=x_cur;
                 y_next=y_cur;
                 done=0;
               end
              
               
            s6:begin
                 error=0;
                 count_next=count_cur;
                 next_state=s1;
                 R_next=R_cur;
                 x_next=R_cur[m:0]+y_cur[(n-m-1)];            
                 y_next=y_cur<<1;
                 done=0;
               end
       default:begin
                error=0;
                count_next=0;
                next_state=s0;
                R_next=R_cur;
                x_next=x_cur;
                y_next=y_cur;
                done=0;
               end
    endcase
end



endmodule
