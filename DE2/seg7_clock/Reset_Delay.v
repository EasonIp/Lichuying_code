module	Reset_Delay (iCLK, oRESET);

	input iCLK;
	
	output reg oRESET;
	
	reg	[19:0] count;

	always @ (posedge iCLK)
		begin
			if(count != 20'hFFFFF)
				begin
					count	<=	count + 20'd1;
					oRESET	<=	1'b0;
				end
			else
				oRESET	<=	1'b1;
		end

endmodule