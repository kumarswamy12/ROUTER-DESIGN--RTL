module router_top(input pkt_valid,clock,resetn,read_enb_0,read_enb_1,read_enb_2,
                   input [7:0]data_in,
 			output [7:0] data_out_0,data_out_1,data_out_2,
			output vld_out_0,vld_out_1,vld_out_2,err,busy);


wire [2:0]write_enb;
wire [7:0]dout;


  router_sync  S1(clock,resetn,detect_add,full_0,full_1,full_2,fifo_empty_0,fifo_empty_1,fifo_empty_2,read_enb_0,read_enb_1,read_enb_2,write_enb_reg,data_in[1:0],
                    write_enb, fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,vld_out_0,vld_out_1,vld_out_2);

   

 router_reg  S2 ( clock,resetn,pkt_valid,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,
                   data_in,err,parity_done,low_packet_valid,dout);


router_fsm   S3 ( clock,resetn,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid,
    data_in[1:0], write_enb_reg,detect_add,lfd_state,laf_state,ld_state,full_state,rst_int_reg,busy);



router_fifo   S4 (clock,resetn,write_enb[0],read_enb_0,soft_reset_0,lfd_state, dout,full_0,fifo_empty_0,data_out_0);

router_fifo   S5 (clock,resetn,write_enb[1],read_enb_1,soft_reset_1,lfd_state, dout,full_1,fifo_empty_1,data_out_1);
 
router_fifo  S6(clock,resetn,write_enb[2],read_enb_2,soft_reset_2,lfd_state, dout,full_2,fifo_empty_2,data_out_2);
                		                                                                  
                     



endmodule

