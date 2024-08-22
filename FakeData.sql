/*******************************************************************************
   Drop Tables
********************************************************************************/
DROP TABLE IF EXISTS [dpm_raynham_detail_scrap_units];
DROP TABLE IF EXISTS [dpm_raynham_targets_scrap_units];


/*******************************************************************************
   Create Tables
********************************************************************************/
CREATE TABLE [dpm_raynham_detail_scrap_units] (
    [KPI_Name] TEXT NOT NULL,
    [Site] TEXT NOT NULL,
    [Date] TEXT NOT NULL,
    [Week] TEXT NOT NULL,
    [Month] TEXT NOT NULL,
    [StandardDate] TEXT NOT NULL,
    [ValueStream] TEXT NOT NULL,
    [Material] TEXT NOT NULL,
    [Order] INTEGER NOT NULL,
    [MRP] TEXT NOT NULL,
    [Value] REAL NOT NULL
);

INSERT INTO dpm_raynham_detail_scrap_units (
    KPI_Name, Site, Date, Week, Month, StandardDate, ValueStream, Material, "Order", MRP, Value
) VALUES (
    'Financial Scrap (Units)', 'Raynham', '20240721', '202411', '202407', '07/21/2024', 
    'Machine Room', '963107710', 57892169, 'DE7', 18.8
);

INSERT INTO dpm_raynham_detail_scrap_units (
    KPI_Name, Site, Date, Week, Month, StandardDate, ValueStream, Material, "Order", MRP, Value
) VALUES (
    'Financial Scrap (Units)', 'Raynham', '20240720', '202411', '202407', '07/20/2024', 
    'Machine Room', '963107710', 57892165, 'DE7', 4.0
);

INSERT INTO dpm_raynham_detail_scrap_units (
    KPI_Name, Site, Date, Week, Month, StandardDate, ValueStream, Material, "Order", MRP, Value
) VALUES (
    'Financial Scrap (Units)', 'Raynham', '20240719', '202411', '202407', '07/19/2024', 
    'Machine Room', '963107710', 57892160, 'DE7', 6.6
);

INSERT INTO dpm_raynham_detail_scrap_units (
    KPI_Name, Site, Date, Week, Month, StandardDate, ValueStream, Material, "Order", MRP, Value
) VALUES (
    'Financial Scrap (Units)', 'Raynham', '20240505', '202404', '202407', '07/30/2024', 
    'Packaging', '578830829', 83532740, 'DE6', 1.76
);

INSERT INTO dpm_raynham_detail_scrap_units (
    KPI_Name, Site, Date, Week, Month, StandardDate, ValueStream, Material, "Order", MRP, Value
) VALUES (
    'Financial Scrap (Units)', 'Raynham', '20240725', '202425', '202407', '04/12/2024', 
    'Assembly Line', '946649188', 58748364, 'DE6', 1.16
);

INSERT INTO dpm_raynham_detail_scrap_units (
    KPI_Name, Site, Date, Week, Month, StandardDate, ValueStream, Material, "Order", MRP, Value
) VALUES (
    'Financial Scrap (Units)', 'Raynham', '20240606', '202412', '202406', '06/06/2024', 
    'Machine Room', '962235837', 49936666, 'DE7', 9.52
);

INSERT INTO dpm_raynham_detail_scrap_units (
    KPI_Name, Site, Date, Week, Month, StandardDate, ValueStream, Material, "Order", MRP, Value
) VALUES (
    'Financial Scrap (Units)', 'Raynham', '20240602', '202410', '202406', '06/02/2024', 
    'Packaging', '123788217', 96428011, 'DE8', 7.05
);

INSERT INTO dpm_raynham_detail_scrap_units (
    KPI_Name, Site, Date, Week, Month, StandardDate, ValueStream, Material, "Order", MRP, Value
) VALUES (
    'Financial Scrap (Units)', 'Raynham', '20240427', '202352', '202312', '10/13/2023', 
    'Assembly Line', '772363663', 60050356, 'DE7', 2.97
);

INSERT INTO dpm_raynham_detail_scrap_units (
    KPI_Name, Site, Date, Week, Month, StandardDate, ValueStream, Material, "Order", MRP, Value
) VALUES (
    'Financial Scrap (Units)', 'Raynham', '20241120', '202404', '202407', '11/02/2024', 
    'Assembly Line', '591889592', 22978915, 'DE8', 3.54
);

INSERT INTO dpm_raynham_detail_scrap_units (
    KPI_Name, Site, Date, Week, Month, StandardDate, ValueStream, Material, "Order", MRP, Value
) VALUES (
    'Financial Scrap (Units)', 'Raynham', '20231216', '202409', '202312', '05/09/2024', 
    'Machine Room', '579666967', 57864572, 'DE7', 6.47
);


INSERT INTO dpm_raynham_detail_scrap_units (
    KPI_Name, Site, Date, Week, Month, StandardDate, ValueStream, Material, "Order", MRP, Value
) VALUES (
    'Financial Scrap (Units)', 'Raynham', '20240608', '202431', '202406', '06/08/2024', 
    'Assembly Line', '267169728', 60518642, 'DE8', 2.73
);

INSERT INTO dpm_raynham_detail_scrap_units (
    KPI_Name, Site, Date, Week, Month, StandardDate, ValueStream, Material, "Order", MRP, Value
) VALUES (
    'Financial Scrap (Units)', 'Raynham', '20240513', '202347', '202309', '05/13/2024', 
    'Assembly Line', '414002179', 40026980, 'DE7', 0.84
);


CREATE TABLE [dpm_raynham_targets_scrap_units] (
    [TargetType] TEXT NOT NULL,
    [Year] INTEGER NOT NULL,
    [Month] INTEGER NOT NULL,
    [Week] TEXT NOT NULL,
    [Date] TEXT NOT NULL,
    [ValueStream] TEXT NOT NULL,
    [Target] REAL NOT NULL
);

INSERT INTO dpm_raynham_targets_scrap_units (
    TargetType, Year, Month, Week, Date, ValueStream, Target
) VALUES (
    'Weekly', 2024, 202407, '202411', '20240721', 'Packaging', 3.49
);

INSERT INTO dpm_raynham_targets_scrap_units (
    TargetType, Year, Month, Week, Date, ValueStream, Target
) VALUES (
    'Weekly', 2024, 202409, '202431', '20240920', 'Assembly Line', 2.14
);

INSERT INTO dpm_raynham_targets_scrap_units (
    TargetType, Year, Month, Week, Date, ValueStream, Target
) VALUES (
    'Weekly', 2024, 202404, '202406', '20240430', 'Machine Room', 1.42
);

INSERT INTO dpm_raynham_targets_scrap_units (
    TargetType, Year, Month, Week, Date, ValueStream, Target
) VALUES (
    'Daily', 2024, 202406, '202436', '20240606', 'Machine Room', 1.74
);

INSERT INTO dpm_raynham_targets_scrap_units (
    TargetType, Year, Month, Week, Date, ValueStream, Target
) VALUES (
    'Daily', 2024, 202406, '202436', '20240607', 'Machine Room', 1.75
);

INSERT INTO dpm_raynham_targets_scrap_units (
    TargetType, Year, Month, Week, Date, ValueStream, Target
) VALUES (
    'Daily', 2024, 202407, '202420', '20231231', 'Machine Room', 2.38
);
