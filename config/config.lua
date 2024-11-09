SDC = {}

---------------------------------------------------------------------------------
-------------------------------Important Configs---------------------------------
---------------------------------------------------------------------------------
SDC.Framework = "qb-core" --Either "qb-core" or "esx"
SDC.Target = "qb-target" --Can be one of these (If "none" is selected it will use TextUi): ["qb-target","ox-target","none"]
SDC.NotificationSystem = "framework" -- ['mythic_old', 'mythic_new', 'tnotify', 'okoknotify', 'ox_lib', 'print', 'framework', 'none'] --Notification system you prefer to use
SDC.UseProgBar = "ox_lib" --If you want to use a progress bar resource, options: ["progressBars", "mythic_progbar", "ox_lib", "none"]

SDC.DispatchSystem = "none" --Can be one of these (If "none" it will use built in police notification) ["none", "cd_dispatch", "ps-dispatch"]

SDC.UpdateInterval = 5 --How Often The Server Loop Sends An Update To All Server Checks (In Seconds)
SDC.CloseEntityDistance = 50 --How close you have to be for an entity to be considered close (For Text UI Only)
---------------------------------------------------------------------------------
-------------------------------Port-A-Potty Configs------------------------------
---------------------------------------------------------------------------------
SDC.PAP = { --Port-A-Potty Main Configs
    Enabled = true, --If you want this to be enabled
    CamFOV = 120.0 --FOV for the camera ontop of port-a-potty
}
SDC.PAPInteractKeybind = {Input = 38, Label = "E"} --Keybind for interacting with Port-A-Potty (Text UI Only)
SDC.PAPKeybinds = { --Keybinds For Inside
    Exit = {Input = "INPUT_DETONATE", InputNum = 47}, --Keybind For Exiting The Port-A-Potty
}
SDC.PAPModels = { --All Port-A-Potty Models
    --EX: "prop_name"

    "prop_portaloo_01a"
}

---------------------------------------------------------------------------------
-------------------------------Dumpster Configs----------------------------------
---------------------------------------------------------------------------------
SDC.Dump = { --Dumpster Main Configs
    Enabled = true, --If you want this to be enabled
    CamFOV = 120.0, --FOV for the camera ontop of dumpster
    SearchCooldown = { --Cooldown for searching the dumpster/trashcan
        Trash = 5, --(In Minutes)
        Dumpster = 5 --(In Minutes)
    },
    Minigame = { --Minigame Configs For Dumpsters/Trashcans
        Trash = {
            Enabled = true, --If you want this to be enabled
            SearchTime = 4, --How long it takes to search trash (In Seconds)
            Checks = 2, --How many key press checks there are
            Difficulty = "easy", -- Options: ["easy", "medium", "hard"]
            Keys = {"w", "a", "s", "d"} --All keys used in keypress check
        },
        Dumpster = {
            Enabled = true, --If you want this to be enabled
            SearchTime = 8, --How long it takes to search dumpsters (In Seconds)
            Checks = 4, --How many key press checks there are
            Difficulty = "easy", -- Options: ["easy", "medium", "hard"]
            Keys = {"w", "a", "s", "d"} --All keys used in keypress check
        }
    },
    RandomItems = { --All Random Item Configs
        DumpsterRandomAmount = {0, 4}, --The Random Amount Of Items Given On Searching Dumpster (Min, Max)
        DumpsterItems = { --Dumpster Search Reward Items
            {Name = "water_bottle", Label = "Bottle Of Water"},
        },
        TrashRandomAmount = {0, 2}, --The Random Amount Of Items Given On Searching Trash (Min, Max)
        TrashItems = { --Trashcan Search Reward Items
            {Name = "water_bottle", Label = "Bottle Of Water"},
        },
    }
}
SDC.DumpsterSearchKeybind = {Input = 38, Label = "E"} --Keybind for searching a Dumpster (Text UI Only)
SDC.DumpsterHideKeybind = {Input = 47, Label = "G"} --Keybind for hiding in a Dumpster (Text UI Only)
SDC.TrashSearchKeybind = {Input = 38, Label = "E"} --Keybind for searching a Trash Can (Text UI Only)
SDC.DumpKeybinds = { --Keybinds For Inside
    Exit = {Input = "INPUT_DETONATE", InputNum = 47}, --Keybind For Exiting The Port-A-Potty
}
SDC.DumpsterModels = { --All Dumpster Models
    --EX: "prop_name"

    "prop_dumpster_4b",
    "prop_dumpster_4a",
    "prop_dumpster_02a",
    "prop_dumpster_01a",
    "prop_dumpster_02b",
}
SDC.TrashCanModels = { --All Trashcan Models
    --EX: "prop_name"

    "prop_bin_01a",
    "prop_bin_02a",
    "prop_bin_05a",
    "prop_bin_11a",
    "prop_bin_11b",
    "prop_bin_10a",
    "prop_bin_10b",
    "prop_bin_12a",
    "prop_bin_07d",
    "prop_bin_06a",
    "prop_bin_08open",
    "prop_bin_delpiero"
}

---------------------------------------------------------------------------------
--------------------------Parking Meter Configs----------------------------------
---------------------------------------------------------------------------------
SDC.Meter = { --Main Parking Meter Configs
    Enabled = true, --If you want this to be enabled
    PricePerMinute = 0.5, --The Price Per Minute For The Meter
    JobsToCheckMeter = { --All Jobs that can check meters
        --EX: ["job_name"] = "Job Label"

        ["police"] = "Police",
    },
    CheckMeterTime = 7, --How long it takes to check a meters payment (In Seconds)
    RobbingMeter = { --Robbing Meter Configs
        Enabled = true, --If you want this to be enabled
        RobTime = 45, --How long it takes to rob the meter (In Seconds)
        MeterRobCooldown = 10, --How long the meter's rob cooldown is for (In Minutes)
        RequiredItems = { --All required items to rob meter
            --EX: ["item_name"] = {Label = "Item Label", NeededAmount = 1}

            ["weapon_hammer"] = {Label =  "Hammer", NeededAmount = 1}
        },
        PrizeMoneyAmts = {100, 800}, --The random amount of money you can get as a reward for robbing (Min, Max)
        Blip = {Sprite = 108, Color = 1, Size = 1.2}, --Blip configs for alerting police of robbery
        JobsToNotify = { --All Jobs notified of a robbery
            --EX: ["job_name"] = "Job Label"

            ["police"] = "Police",
        },
        Minigame = { --Robbing Minigame Configs
            Enabled = true, --If you want this to be enabled
            Checks = 4, --How many key press checks there are
            Difficulty = "easy", -- Options: ["easy", "medium", "hard"]
            Keys = {"w", "a", "s", "d"}, --All keys used in keypress check
        },
    }
}
SDC.MeterInteractKeybind = {Input = 38, Label = "E"} --Keybind for using a Parking Meter (Text UI Only)
SDC.MeterPoliceKeybind = {Input = 47, Label = "G"} --Keybind for police checking a Parking Meter (Text UI Only)
SDC.MeterRobKeybind = {Input = 49, Label = "F"} --Keybind for robbing a Parking Meter (Text UI Only)
SDC.MeterModels = { --All Parking Meter Models
    --EX: "prop_name"

    "prop_parknmeter_01",
    "prop_parknmeter_02"
}

---------------------------------------------------------------------------------
-------------------------------Toilet Configs------------------------------------
---------------------------------------------------------------------------------
SDC.Toilets = { --Main Toilet Configs
    Enabled = true, --If you want this to be enabled
}
SDC.ToiletUseStandingKeybind = {Input = 38, Label = "E"} --Keybind for using a Toilet Standing (Text UI Only)
SDC.ToiletUseSittingKeybind = {Input = 47, Label = "G"} --Keybind for using a Toilet Sitting (Text UI Only)
SDC.ToiletKeybinds = { --Keybinds While Using Toilet
    Exit = {Input = "INPUT_DETONATE", InputNum = 47}, --Keybind For Leaving The Toilet
}
SDC.ToiletModels = { --All Toilet Models
    --EX: {Model = "prop_name", Offset = {vec3(0.0, -0.6, 0.0)}},

    {Model = "prop_toilet_01", Offset = {vec3(0.0, -0.6, 0.0)}},
    {Model = "prop_toilet_02", Offset = {vec3(0.0, -0.6, 0.0)}}
}

---------------------------------------------------------------------------------
---------------------------Vending Machines Configs------------------------------
---------------------------------------------------------------------------------
SDC.Vending = { --Main Vending Machine Configs
    Enabled = true, --If you want this to be enabled
    Machines = { --All Machine Configs
        --[[
            EX:

            {
                Label = "Vending Machine Label", --Label For Vending Machine
                Models = {"prop_name"}, --All Models For This Typoe Of Vending Machine
                Icon = "burger", --Font Awesome Icon For Menu
                ItemsForSale = { --All Items For Sale In Vending Machine
                    --EX: {Name = "item_name", Label = "Item Label", Price = 1, Stock = 1},
                },
            }
        ]]

        {
            Label = "Food Vending Machine",
            Models = {"prop_vend_snak_01"},
            Icon = "burger",
            ItemsForSale = {
                {Name = "twerks_candy", Label = "Twerks Bar", Price = 2, Stock = 25},
                {Name = "snikkel_candy", Label = "Snikkel Bar", Price = 2, Stock = 25},
            },
        },
        {
            Label = "Drink Vending Machine",
            Models = {"prop_vend_soda_01", "prop_vend_soda_02"},
            Icon = "whiskey-glass",
            ItemsForSale = {
                {Name = "kurkakola", Label = "Cola", Price = 2, Stock = 50},
            },
        },
        {
            Label = "Coffee Vending Machine",
            Models = {"prop_vend_coffe_01"},
            Icon = "mug-hot",
            ItemsForSale = {
                {Name = "coffee", Label = "Coffee", Price = 5, Stock = 50},
            },
        },
        {
            Label = "Water Vending Machine",
            Models = {"prop_vend_water_01", "prop_watercooler"},
            Icon = "bottle-droplet",
            ItemsForSale = {
                {Name = "water_bottle", Label = "Bottle Of Water", Price = 1, Stock = 50},
            },
        },
    }
}
SDC.VendingInteractKeybind = {Input = 38, Label = "E"} --Keybind for using a Vending Machine (Text UI Only)

---------------------------------------------------------------------------------
----------------------------------Chairs Configs---------------------------------
---------------------------------------------------------------------------------
SDC.Chairs = { --Main Chair Configs
    Enabled = true,--If you want this to be enabled
}
SDC.ChairInteractKeybind = {Input = 38, Label = "E"} --Keybind for using a Chairs (Text UI Only)
SDC.ChairKeybinds = {--Keybinds While Sitting In Chair
    Exit = {Input = "INPUT_DETONATE", InputNum = 47}, --Keybind For Leaving The Chair
}
SDC.ChairModels = {--All Chair Models
    --EX: {Model = "prop_name", Offset = {vec3(0.0, -0.5, 0.0)}},

    {Model = "prop_off_chair_05", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_table_01_chr_a", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_skid_chair_02", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "vw_prop_vw_offchair_01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "vw_prop_vw_offchair_02", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_clown_chair", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "h4_prop_h4_chair_02a", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "ex_prop_offchair_exec_02", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_table_06_chr", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "tr_prop_tr_chair_01a", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "xm_prop_x17_corp_offchair", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "ex_prop_offchair_exec_03", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "ex_prop_offchair_exec_01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_cs_office_chair", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_chair_08", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_chair_02", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_chair_01a", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_old_wood_chair_lod", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_table_03_chr", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_chair_05", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "xm3_prop_xm3_folding_chair_01a", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_table_05_chr", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_table_02_chr", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_off_chair_04", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "bkr_prop_clubhouse_chair_01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_table_03b_chr", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_yacht_seat_01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_chair_04b", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_rub_couch03", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "bkr_prop_weed_chair_01a", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_old_wood_chair", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_table_01_chr_b", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_chair_03", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_chateau_chair_01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_gc_chair02", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_skid_chair_01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_chair_06", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_table_04_chr", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_chair_04a", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_chair_01b", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_torture_ch_01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_chair_07", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_chair_09", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_yacht_seat_03", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_skid_chair_03", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_rock_chair_01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_sol_chair", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_couch_sm_05", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_chair_10", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_yaught_chair_01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_off_chair_01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_bench_01a", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_bench_01b", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_bench_01c", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_bench_02", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_bench_03", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_bench_04", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_bench_05", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_bench_06", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_bench_07", Offset = {vec3(0.0, -0.45, 0.0)}},
    {Model = "prop_bench_08", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_bench_09", Offset = {vec3(0.0, -0.31, 0.0)}},
    {Model = "prop_bench_10", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_bench_11", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_fib_3b_bench", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_ld_bench01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_wait_bench_01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "v_club_stagechair", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "hei_prop_heist_off_chair", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "hei_prop_hei_skid_chair", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_direct_chair_01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_direct_chair_02", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_off_chair_03", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_off_chair_04b", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_off_chair_04_s", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_old_deck_chair", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_wheelchair_01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_wheelchair_01_s", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "p_armchair_01_s", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "p_clb_officechair_s", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "p_dinechair_01_s", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "p_ilev_p_easychair_s", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "p_soloffchair_s", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "p_yacht_chair_01_s", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "v_club_officechair", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "v_corp_bk_chair3", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "v_corp_cd_chair", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "v_corp_offchair", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "v_ilev_chair02_ped", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "v_ilev_hd_chair", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "v_ilev_p_easychair", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "v_ret_gc_chair03", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_ld_farm_chair01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "v_ilev_leath_chr", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "hei_prop_yah_seat_01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "hei_prop_yah_seat_02", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "hei_prop_yah_seat_03", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_waiting_seat_01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_yacht_seat_02", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_hobo_seat_01", Offset = {vec3(0.0, -0.65, 0.0)}},
    {Model = "prop_rub_couch01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "miss_rub_couch_01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_ld_farm_couch01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_ld_farm_couch02", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_rub_couch02", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_rub_couch04", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "p_lev_sofa_s", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "p_res_sofa_l_s", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "p_v_med_p_sofa_s", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "p_yacht_sofa_01_s", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "v_ilev_m_sofa", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "v_res_tre_sofa_s", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "v_tre_sofa_mess_a_s", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "v_tre_sofa_mess_b_s", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "v_tre_sofa_mess_c_s", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_roller_car_01", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "prop_roller_car_02", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "v_ret_gc_chair02", Offset = {vec3(0.0, -0.5, 0.0)}},
    {Model = "v_serv_ct_chair02", Offset = {vec3(0.0, -0.5, -0.5)}},
}
