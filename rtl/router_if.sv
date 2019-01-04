
//interface


interface router_if(input bit clock);
 logic [7:0]data_in;
   logic busy;
	logic error;
    logic pkt_valid;
     logic reset;
      logic read_enb;
        logic [7:0]data_out;
		logic valid_out;
                   bit clk;
		assign clk=clock; 




//write driver cloking block
clocking  wr_cb @(posedge clock);
               default input #1 output #1;
   
output data_in;
output valid_out;
output reset;
output pkt_valid;
input busy;
input error;
  endclocking


//read driver clocking 
clocking rd_cb @(posedge clock);
   default input #1 output #1;

   output read_enb;
     input valid_out;
endclocking

//write monitor clocking block

clocking wr_mon_cb @(posedge clock);
default input #1 output #1;
input data_in;
input pkt_valid;
input busy;
endclocking;


//read monitor clocking block
clocking rd_mon_cb @(posedge clock);
default input #1 output #1;
input data_out;
input read_enb;
endclocking

//modports

//1.write driver
modport WR_DR(clocking wr_cb);
//2.write monitor
modport WR_MON(clocking wr_mon_cb);
//3.read driver
modport RD_DR(clocking rd_cb);
//4.read moitor
modport RD_MON(clocking rd_mon_cb);



endinterface
