module O : interface
    DRAM_ADDR DRAM_BA DRAM_CAS_N 
    DRAM_CKE DRAM_CLK DRAM_CS_N
    DRAM_DQM DRAM_RAS_N DRAM_WE_N
end

module T : interface DRAM_DQ end

