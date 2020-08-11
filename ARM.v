module arm(
    input clk, rst);



    IF_stage_module if_stage_module(
        .clk(clk),
        .rst(rst),
        .freeze_in(),
        .branch_taken_in(),
        .flush_in(),
        .branchAddr_in(),
        .pc_out(),
        .instruction_out()
    );


    ID_stage_module id_stage_module(
        // inputs
        .clk(clk),
        .rst(rst),
        .flush(),
        .freeza(),
        .pc_in(),
        .instruction_in(),
        .status_reg_in(),
        .reg_file_wb_data(),
        .reg_file_wb_address(),
        .reg_file_wb_en(),
        .hazard(),
        // outputs
        .two_src_out(),
        .ignore_hazard_out(),
        .reg_file_second_src_out(),
        .reg_file_first_src_out(),
        .pc_out(),
        .mem_read_en_out(),
        .mem_write_en_out(),
        .wb_enable_out(),
        .immediate_out(),
        .branch_taken_out(),
        .status_write_enable_out(),
        .execute_command_out(),
        .reg_file_out1(),
        .dest_reg_out(),
        .signed_immediate_out(),
        .shift_operand_out(),
        .status_reg_out(),
        .staged_reg_file_second_src_out(),
        .staged_reg_file_first_src_out(),
    );


    EXE_stage_module exe_stage_module(
        // inputs
        .clk(clk),
        .rst(rst),
        .freeza(freeza),
        .pc_in(),
        .wb_en_in(),
        .mem_r_en_in(),
        .mem_w_en_in(),
        .status_w_en_in(),
        .branch_taken_in(),
        .immd(),
        ,exe_cmd(),
        .val_Rn(),
        .val_Rm_in(),
        .dest_in(),
        .signed_immd_24(),
        .shift_operand(),
        .status_reg_in(),
        .alu_mux_sel_src1(),
        .alu_mux_sel_src2(),
        .MEM_wb_value(),
        .WB_wb_value(),
         // outputs
        .wb_en_out(),
        .mem_r_en_out(),
        .mem_w_en_out(),
        .alu_res_out(),
        .val_Rm_out(),
        .dest_out(),
        .wb_en_hazard_in(),
        .dest_hazard_in(),
        .status_w_en_out(),
        .branch_taken_out(),
        .status_register_out(),
        .branch_address_out()
    );


    MEM_stage_module mem_stage_module(
        .clk(clk),
        .rst(rst),
        .freeze(),
        .wb_en_in(),
        .mem_r_en_in(),
        .mem_w_en_in(),
        .alu_res_in(),
        .val_Rm(),
        .dest_in(),
        .wb_en_out(),
        .mem_r_en_out(),
        .alu_res_out(),
        .mem_res_out(),
        .dest_out(),
        .wb_en_hazard_in(),
        .ready(),
        .dest_hazard_in()
    );



    WB_stage wb_stage(
        .clk(clk),
        .rst(rst),
        .mem_read_enable(),
        .wb_enable_in(),
        .alu_result(),
        .data_memory(),
        .wb_dest_in(),
        .wb_enable_out(),
        .wb_dest_out(),
        .wb_value()
    );


    hazard_detection_unit hazard_detection_unit(
        .with_forwarding(),
        .have_two_src(),
        .ignore_hazard(),
        .ignore_from_forwarding(),
        .EXE_mem_read_en(),
        .src1_address(),
        .src2_address(),
        .exe_wb_dest(),
        .mem_wb_dest(),
        .exe_wb_en(),
        .mem_wb_en(),
        .hazard_detected()
    );

    forwarding forward_unit(
        .en_forwarding(),
        .WB_wb_en(),
        .MEM_wb_en(),
        .MEM_dst(),
        .WB_dst(),
        .ID_src1(),
        .ID_src2(),
        .sel_src1(),
        .sel_src2(),
        .ignore_hazard()
    );

endmodule