      module router_fifo(input clock,resetn,write_enb,read_enb,soft_reset,lfd_state,
		                     input[7:0]data_in,
             output  full,empty,
            output reg[7:0]data_out);

                parameter DEPTH=16;
                  parameter WIDTH=9;
                  parameter ADDR=5;

             
               reg [6:0]count;

         reg [WIDTH-1:0]mem[DEPTH-1:0];
         reg [ADDR-1:0]rd_ptr,wr_ptr;
           reg lfd;

            integer i;
     
always@(posedge clock)
begin
if(~resetn)
lfd<=0;
else
lfd<=lfd_state;
end
//write logic
          
            always@(posedge clock)
                 begin
                    
                        if(!resetn)
                              begin
                                //data_out<=0;
                                
 				                   
										   for(i=0;i<DEPTH;i=i+1)
                                   mem[i]<=0;
										 end
										 
                               else if(soft_reset)
                              begin
                                //data_out<=0;
                                 
                                
                             
                             for(i=0;i<DEPTH;i=i+1)
                                   mem[i]<=0;
                                end
                                
                                    else
                                     begin
                                if(write_enb && ~full)
                              {mem[wr_ptr[3:0]][8],mem[wr_ptr[3:0]][7:0]}<={lfd,data_in};
										/*if(read_enb && ~empty )
				                	data_out<=mem[rd_ptr[3:0]];*/
										
                                    end
												end


// read logic
          

             always@(posedge clock)
                 begin
                      
                        if(!resetn)
                              begin
                                data_out<=0;
                                
 				                
									  /*for(j=0;j<DEPTH;j=j+1)
                                  mem[i]<=0;*/
											 end
									  
                               else if(soft_reset)
                              begin
                                data_out<=0;
                                 
                                
                             
                             /*for(j=0;j<DEPTH;j=j+1)
                                  mem[j]<=0;*/
                          end
								  
                            
				              else
					           begin
                  if(read_enb && ~empty )
					data_out<=mem[rd_ptr[3:0]][7:0];
			      end
					end
                       

//pointer logic							  
								always@(posedge clock)
								begin
								if(!resetn)
								begin
					             			rd_ptr<=0;
					    				wr_ptr<=0;
								end
                             if(soft_reset)
                               begin
                                 rd_ptr<=0;
                                  wr_ptr<=0;
 									end
			  		 			  else
		                         begin
		     						if(write_enb && ~full)
								wr_ptr<=wr_ptr+1'b1;
								if(read_enb && ~empty )
                          rd_ptr<=rd_ptr+1'b1;
                          end
								   end
                        						  
                                            

      ///counter logic  	       					
                    
                     
                     always@(posedge clock)
			  begin
                               if(!resetn)
                           count<=0;
                           else if(soft_reset)
                            count<=0;
			 else if(read_enb && ~empty)
				begin
                                 if (mem[rd_ptr[3:0]][8])
					count<=mem[rd_ptr[3:0]][7:2] + 1'b1;
                              	else 
                                   /* if(count>0)
                                 	count<=count-1'b1;*/         
                              // else
                                   	count<=0;    
                             	end
		/*	else
				  count<=0;*/
			  end
         	      

                    
                  	assign full = {wr_ptr[4] != rd_ptr[4]&&wr_ptr[3:0]==rd_ptr[3:0]} ? 1'b1:1'b0;
           	          assign empty = (wr_ptr == rd_ptr);
              								 
                               endmodule


                     
                 
