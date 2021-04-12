/*
 * ------------------------------------------------------------------------------------
 *   Copyright (c) SAS Institute Inc.
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 * ---------------------------------------------------------------------------------------
 *
 */

 import createTempVAReport from '../lib/createTempVAReport';

 async function loadAutotuneVAReport(store, viya) {

   let { appEnv, services, session } = viya;
   let folderName      = appEnv.WORK_FOLDER_NAME;
   let tempReportName  = appEnv.TEMP_REPORT_NAME;
   let dataTableName   = appEnv.DATA_TABLE_NAME;
   let caslibName      = appEnv.WORK_LIB_NAME;
   let host            = appEnv.host;

   await validateSetup(store, session, caslibName, dataTableName);
   debugger;
   let {columns, labels, types} = await getDatasetColumnNames ( store, session, dataTableName, caslibName );
   debugger;
   let newContent = await updateVAReportJson ( store, session, columns, labels, types, dataTableName, caslibName );
   debugger;
   let reportUri = await createTempVAReport( store, services, folderName, tempReportName, newContent );
   console.log( 'VA report =', reportUri );

  let options = "&appSwitcherDisabled=true"+
                "&reportViewOnly=true"+
                "&printEnabled=false"+
                "&sharedEnabled=false"+
                "&informationEnabled=false"+
                "&commentEnabled=false"+
                "&sas-welcome=false"+
                "&reportContextBar=false";

    let href = `${host}/SASVisualAnalytics/?reportUri=${reportUri}${options}`;
    console.log('VA report href =',href);
    return href;
}

async function validateSetup(store, session, caslibName, dataTableName) {
    debugger;
    await checkCaslibExists ( store, session, caslibName );
    await checkDatasetExists ( store, session, dataTableName, caslibName );
 }


async function checkCaslibExists (store, session, caslibName) {

  // 'CASUSER' is guaranteed to exist
  if(caslibName.startsWith('CASUSER')) return;

  // CASL code to execute 'queryCaslib' action and return the value
  let caslStatements =
    `
    table.queryCaslib result=r / caslib='${caslibName}';
    run;
    send_response( r ) ;
    `;
  debugger;

  // run the above CASL code using 'runCASL' action
  let payload = {
    action : 'sccasl.runCasl',
    data   : { code : caslStatements },
  };
  let resObj = await store.runAction(session, payload);

  // extract the 'exists' value from the result obj;
  let existsBoolean = resObj.items('results',caslibName);
  debugger;
  if(!existsBoolean) {
    throw new Error(`Caslib '${caslibName}' cannot be found.\n`+
        'Verify the caslib name entered.');
  }
}

async function checkDatasetExists (store, session, datasetName, caslibName) {

  // CASL code to execute 'tableExists' action and return the value
  let caslStatements =
    `
    table.tableExists result=r / table='${datasetName}' caslib='${caslibName}';
    run;
    send_response( r ) ;
    `;
  debugger;

  // run the above CASL code using 'runCASL' action
  let payload = {
    action : 'sccasl.runCasl',
    data   : { code : caslStatements },
  };
  let resObj = await store.runAction(session, payload);

  // extract the 'exists' value from the result obj;
  let existsVal = resObj.items('results','exists');
  debugger;
  if(existsVal === 0) {
    throw new Error(`Dataset '${datasetName}' in caslib '${caslibName}' cannot be found.\n`+
        'Verify the dataset name entered.');
  }
}

async function getDatasetColumnNames (store, session, datasetName, caslibName) {

  // CASL code to execute 'columnInfo' action and return the table
  let caslStatements =
    `
    table.columnInfo result=r /
      table={name='${datasetName}' caslib='${caslibName}'};
    run;
    send_response( r ) ;
    `;
  debugger;

  // run the above CASL code using 'runCASL' action
  let payload = {
    action : 'sccasl.runCasl',
    data   : { code : caslStatements },
  };
  let resObj = await store.runAction(session, payload);

  // extract the table rows from the result obj;
  // read the first item in each row:
  // these are the names of the columns in 'datasetName' table
  let itemRows = resObj.items('results','ColumnInfo','rows');
  let columns = [];
  let labels  = [];
  let types   = [];
  debugger;
  itemRows.map((row)=> {
    columns.push(row.get(0));
    labels.push(row.get(1));
    types.push(row.get(3)); /* 'char' or 'double' */
    return;
  });
  console.log('column names =', columns)
  debugger;
  return {columns: columns, labels: labels, types: types};
}

async function getBaselineObjValue(store, session, datasetName, caslibName, objName) {

  // CASL code to execute 'fetch' action and return the obj value
  let caslStatements =
    `
    table.fetch result=r /
      table={name='${datasetName}' caslib='${caslibName}' where='Evaluation=0' vars='${objName}'}
      index=false
      ;
    run;
    send_response( r ) ;
    `;
  debugger;

  // run the above CASL code using 'runCASL' action
  let payload = {
    action : 'sccasl.runCasl',
    data   : { code : caslStatements },
  };
  let resObj = await store.runAction(session, payload);

  let objVal = resObj.items('results','Fetch','rows',0,0);
  return objVal;
}

async function updateVAReportJson (store, session, columnNamesArray, colLabelsArray, colTypesArray, datasetName, caslibName) {

  // column names array example (tuneGrdientBoostTree with 2nd objective!):
  //   "Evaluation",
  //  "Iteration",
  //  "M",
  //  "LEARNINGRATE",
  //  "SUBSAMPLERATE",
  //  "LASSO",
  //  "RIDGE",
  //  "NBINS",
  //  "QUINTILEBIN",
  //  "MAXLEVEL",
  //  "LEAFSIZE",
  //  "MeanSqLogErr",
  //  "ScoreCpuTime",
  //  "EvalTime", <-- playpen modification!
  //  "EvalType"

  // some simple validation of the dataset
  let nCol = columnNamesArray.length;
  if(columnNamesArray[0] !== 'Evaluation' || columnNamesArray[1] !== 'Iteration' ||
      columnNamesArray[nCol-1] !== 'EvalType')
  {
    throw new Error('Invalid column names found in dataset\n'+
        `(dataset='${datasetName}', caslib='${caslibName}').\n`+
        'Make sure that a correct Autotune history dataset is seleted.');
  }
  let objName, objName2;
  let objName_lbl, objName2_lbl;

  // Assume the parm/obj/etc. order is fixed!
  // We can have oneor tewo objectives.
  // The 2nd to last column is the primary Objective;
  // UNLESS we have a 2nd objective!
  objName      = columnNamesArray[nCol-3];
  objName_lbl  = colLabelsArray[nCol-3];
  objName2     = "";
  objName2_lbl = "";
  let nParms = nCol - 5; // Evaluation, Iteration, Obj, EvalTime, EvalType
  // if a second obj was used, the primary obj column is up by one
  if(objName === 'ScoreCpuTime' || objName === 'TrainCpuTime') {
    objName2     = objName;
    objName2_lbl = objName_lbl
    objName      = columnNamesArray[nCol-4];
    objName_lbl  = colLabelsArray[nCol-4];
    nParms       = nParms - 1;
  }
  // exclude the non-numeric parms - cannot (easily) use them for our plots
  let parmNames  = [];
  let parmLabels = [];
  for(let i=2; i<(nParms+2); i++) {
    let type = colTypesArray[i];
    if(type === 'double') {
      parmNames.push(columnNamesArray[i]);
      parmLabels.push(colLabelsArray[i]);
    }
  }
  nParms = parmNames.length;
  debugger;

  // get baseline obj value (for setting reference line in VA plots)
  let baselineObjVal = await getBaselineObjValue(store, session, datasetName, caslibName, objName);
  debugger;

  // select the VA report file based on the number of the hyperparameters;
  let fPath = `./va_reports/VA_Report_${nParms}_Parms.txt`;

  // read report JSON from the server file
  // let contents = loadFile(fPath); <-- works with file.json names, parses and creates an obj immediately
  var xmlhttp = new XMLHttpRequest();
  xmlhttp.open("GET", fPath, false);
  xmlhttp.send();
  if (xmlhttp.status !== 200) {
    throw new Error(`Failed when loading '${fPath}' file from the server`);
  }
  let contents = xmlhttp.responseText;

  // replace special tags with the hyperparameters and obj names
  contents = contents.replace( new RegExp('_AUTOTUNE_DATASET_NAME_'    , 'g'), datasetName    );
  contents = contents.replace( new RegExp('_AUTOTUNE_CASLIB_NAME_'     , 'g'), caslibName     );
  contents = contents.replace( new RegExp('_AUTOTUNE_OBJECTIVE_NAME_2_', 'g'), objName2       );
  contents = contents.replace( new RegExp('_AUTOTUNE_OBJECTIVE_NAME_'  , 'g'), objName        );
  contents = contents.replace( new RegExp('_AUTOTUNE_OBJECTIVE_LABEL_2_','g'), objName2_lbl   );
  contents = contents.replace( new RegExp('_AUTOTUNE_OBJECTIVE_LABEL_' , 'g'), objName_lbl    );
  contents = contents.replace( new RegExp('_AUTOTUNE_BASELINE_OBJ_VAL_', 'g'), baselineObjVal );

  for(let i=0; i<nParms; i++) {
    contents = contents.replace( new RegExp(`_AUTOTUNE_PARM_${i+1}_` , 'g'), parmNames[i]);
    contents = contents.replace( new RegExp(`_AUTOTUNE_LABEL_${i+1}_`, 'g'), parmLabels[i]);
  }
  debugger;
  return contents;
}

export {validateSetup, loadAutotuneVAReport};
