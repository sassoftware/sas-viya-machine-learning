let env = {
	WORK_LIB_NAME   : `${process.env.WORK_LIB_NAME}`,
	DATA_TABLE_NAME : `${process.env.DATA_TABLE_NAME}`,
	host            : `${process.env.VIYA_SERVER}`,
	WORK_FOLDER_NAME: `${process.env.WORK_FOLDER_NAME}`,
	TEMP_REPORT_NAME: `${process.env.TEMP_REPORT_NAME}`
};
return env;