module router_fsm(input clock,resetn,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid,
    input [1:0]data_in,
  output  write_enb_reg,detect_add,lfd_state,laf_state,ld_state,full_state,
               rst_int_reg,busy);



reg[7:0]state;
reg[7:0]next_state;

parameter  DECODE_ADDRESS =8'd1;
parameter  CHECK_PARITY_ERROR = 8'd128;
parameter WAIT_TILL_EMPTY  = 8'd64;
parameter LOAD_PARITY = 8'd8;
parameter LOAD_FIRST_DATA=8'd2;
parameter LOAD_DATA = 8'd4;
parameter FIFO_FULL_STATE = 8'd16;
parameter LOAD_AFTER_FULL=8'd32;

//reset

always@(posedge clock)
begin
if(!resetn)
 state<=DECODE_ADDRESS;
else if((soft_reset_0 && data_in ==2'b00) ||(soft_reset_1 && data_in ==2'b01) ||(soft_reset_2 && data_in ==2'b10)) 
state<=DECODE_ADDRESS;
else
state<=next_state;
end



always@(*)
begin
case(state)
        
DECODE_ADDRESS:
              begin  
if((pkt_valid && (data_in[1:0] ==0) && ~fifo_empty_0)||( pkt_valid && (data_in[1:0]==1) && ~fifo_empty_1) || ( pkt_valid && (data_in[1:0] ==2) && ~fifo_empty_2))
 		next_state=WAIT_TILL_EMPTY;

else if((pkt_valid && (data_in[1:0] ==0) && fifo_empty_0)||( pkt_valid && (data_in[1:0] ==1) &&  fifo_empty_1) || ( pkt_valid && (data_in[1:0] ==2) && fifo_empty_2))
 		next_state=LOAD_FIRST_DATA;

else
next_state = DECODE_ADDRESS;
end
LOAD_FIRST_DATA:


next_state = LOAD_DATA;

LOAD_DATA:
begin

if(fifo_full)
  next_state=FIFO_FULL_STATE;
else if(fifo_full ==0 && pkt_valid==0)
 next_state=LOAD_PARITY;
else
next_state=LOAD_DATA;
end

LOAD_PARITY:


next_state=CHECK_PARITY_ERROR;

FIFO_FULL_STATE:
begin
 

if(fifo_full==0)
next_state=LOAD_AFTER_FULL;
else
next_state=FIFO_FULL_STATE;
end

LOAD_AFTER_FULL:
begin
 next_state=LOAD_AFTER_FULL;
if(parity_done == 0 && low_packet_valid ==0 )
   next_state=LOAD_DATA;
else if(parity_done == 0 && low_packet_valid == 1)

 next_state=LOAD_PARITY;

else if(parity_done)
 next_state=DECODE_ADDRESS;
end


WAIT_TILL_EMPTY:
begin
             next_state=WAIT_TILL_EMPTY;
		
		if((fifo_empty_0 || fifo_empty_1 || fifo_empty_2))


    next_state=LOAD_FIRST_DATA;

else if((~fifo_empty_0 ||  ~fifo_empty_1 || ~fifo_empty_2))
next_state=WAIT_TILL_EMPTY;
end

CHECK_PARITY_ERROR:
begin

if(fifo_full)
next_state=FIFO_FULL_STATE;

else 
next_state=DECODE_ADDRESS;
end
endcase
end

assign detect_add = (state == DECODE_ADDRESS);
assign lfd_state = (state == LOAD_FIRST_DATA );
assign busy = (state == LOAD_FIRST_DATA || state == LOAD_PARITY || state == FIFO_FULL_STATE || state == LOAD_AFTER_FULL || state == WAIT_TILL_EMPTY || state == CHECK_PARITY_ERROR);
assign ld_state = (state == LOAD_DATA);
assign write_enb_reg = (state == LOAD_DATA || state== LOAD_PARITY ||state== LOAD_AFTER_FULL);
assign laf_state = (state == LOAD_AFTER_FULL);
assign rst_int_reg = (state == CHECK_PARITY_ERROR);
assign full_state = (state == FIFO_FULL_STATE);

endmodule
