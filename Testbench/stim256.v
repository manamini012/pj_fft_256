//----------------------------------------------------------------------
//	Test Stimuli
//----------------------------------------------------------------------
initial begin : STIM
	wait (reset == 1);
	wait (reset == 0);
	repeat(10) @(posedge clock);

	fork
		begin
			LoadInputData("input256.txt");
			GenerateInputWave;
		end
		
		begin
			wait (do_en == 1);
			repeat(256) @(posedge clock);
			SaveOutputData("output256.txt");
			@(negedge clock);
		end
	join

	repeat(10) @(posedge clock);
	$finish;
end
initial begin : TIMEOUT
	repeat(10000) #20;	//  1000 Clock Cycle Time
	$display("[FAILED] Simulation timed out.");
	$finish;
end

