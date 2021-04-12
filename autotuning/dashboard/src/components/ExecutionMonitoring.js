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

import React from 'react';
import { withStyles } from '@material-ui/core/styles';
import {AppContext} from '../providers';
import {loadAutotuneVAReport,validateSetup} from '../lib/loadAutotuneVAReport';
// import validateSetup from '../lib/loadAutotuneVAReport';
import CircularIndeterminate from '../helpers/CircularIndeterminate';
import { Typography, Button, FormLabel, TextField } from '@material-ui/core';

const styles = theme => ({
  root: {
    display: 'flex',
  },
  sasBlueBackground: {
    backgroundColor: '#0378CD',
  },
});

class ExecutionMonitoring extends React.Component {

  static contextType = AppContext;

  constructor(props) {
    super(props);
    this.state = {
      href        : null,
      err         : null,
      isLoading   : false,
      data        : props.data,
      datasetName : "MY_HISTORY_DATASET",
      caslibName  : "MY_CASLIB",
    }
  }


  componentDidMount() {
    debugger;
    let { appEnv } = this.context.viya;
    this.setState( {
      datasetName : appEnv.DATA_TABLE_NAME,
      caslibName  : appEnv.WORK_LIB_NAME,
    } );
  }

  componentWillUnmount() {
    debugger;
    let { appEnv } = this.context.viya;
    appEnv.DATA_TABLE_NAME = this.state.datasetName.toUpperCase();
    appEnv.WORK_LIB_NAME   = this.state.caslibName.toUpperCase();
  }

  launchAutotuneMonitoringClicked = () => {
    debugger;
    let { store, viya } = this.context;
    let { appEnv, session } = viya;
    let changedNames = false;
    if( appEnv.DATA_TABLE_NAME != this.state.datasetName.toUpperCase() ||
        appEnv.WORK_LIB_NAME   != this.state.caslibName.toUpperCase())
    {
      // try {
      //   await validateSetup(store, session, this.state.caslibName.toUpperCase(), this.state.datasetName.toUpperCase());
      // } catch( err ) {
      //   console.log(err);
      //   let msg = err.toString();
      //   if(err && err.stack && err.message && err.name) {
      //     msg = err.name + ":\n" + err.message;
      //   }
      //   alert(msg);
      //   return;
      // }
      appEnv.DATA_TABLE_NAME = this.state.datasetName.toUpperCase();
      appEnv.WORK_LIB_NAME   = this.state.caslibName.toUpperCase();
      this.setState( { href: null, err: null, isLoading: true } );
      // this.state.href = null;
      changedNames = true;
    }
    if ( this.state.href === null || changedNames == true) {
      loadAutotuneVAReport( store, viya )
      .then( href => {
        this.setState( { href: href, error: null, isLoading: false } );
      })
      .catch( err => {
        console.log(err);
        let msg = err.toString();
        if(err && err.stack && err.message && err.name) {
          msg = err.name + ":\n" + err.message;
        }
        else {
          try {
            let obj = JSON.parse(err);
            if(obj && obj.log) {
              msg = "Error when updating/loading the VA report.\n"+
                  "Viya server log messages:\n" + obj.log;
            }
          } catch(e) {}
        }
        // this.setState( { href: null, err: msg, isLoading: false } );
        this.setState( { err: msg, isLoading: false } );
        alert(msg);
        // switch display back to 'Setup' page
        //this.props.history.push( '/setup' );
      });
      this.setState( { href: null, err: null, isLoading: true } );
    }
    else {
      this.setState( { isLoading: false } );
    }
  }

  iframeLoaded = () => {
    this.setState({
      isLoading: false
    });
  }

  keyPressedDatasetName = (ev) => {
    if (ev.key === 'Enter') {
      this.launchAutotuneMonitoringClicked();
      ev.preventDefault();
    }
  }

  render() {
    const { classes } = this.props;
    let show;
    let topBar =
        <div>
        <center>
        <table>
          <tr style={{ height:'50px', verticalAlign:'top' }}>
            <td>
              <FormLabel component="legend">
                <Typography variant="subtitle1" color="black"><b>Caslib:</b></Typography>
              </FormLabel>
            </td>
            <td style={{ paddingBottom:'10px', paddingLeft:'10px',width:'150px' }}>
              <TextField
                value={this.state.caslibName}
                onChange={(e) => this.setState({ caslibName: e.target.value })}
                hintText="Enter dataset name"
                fullWidth
                />
            </td>
            <td style={{ paddingLeft:'50px' }}>
              <FormLabel component="legend">
                <Typography variant="subtitle1" color="black"><b>Autotune History Table:</b></Typography>
              </FormLabel>
            </td>
            <td style={{ paddingBottom:'10px', paddingLeft:'10px',width:'300px' }}>
              <TextField
                value={this.state.datasetName}
                onChange={(e) => this.setState({ datasetName: e.target.value })}
                hintText="Enter dataset name"
                fullWidth
                onKeyPress={ this.keyPressedDatasetName }
                />
            </td>
            <td style={{ paddingLeft:'70px' }}>
              <Button
                variant = "contained"
                color   = "primary"
                type    = "submit"
                onClick = { this.launchAutotuneMonitoringClicked }
                classes = {{ root: classes.sasBlueBackground }}
              >
              LOAD
              </Button>
            </td>
          </tr>
        </table>
        </center>
      </div>
    ;

    if ( this.state.isLoading === true ) {
      show =
      <div>
        { topBar }
        <div style={{ height:'100px', verticalAlign:'bottom' }}><CircularIndeterminate/></div>
      </div>
      ;
    }
    else if ( this.state.href === null ) {

        show =
          <div>
            { topBar }
            <div id="imageDiv">
              <img src='./images/autotune_splash.png' alt="" style={{ height:'600px',marginTop:'50px' }}/>
            </div>
          </div>
        ;
    }
    else {
      show =
        <div>
          { topBar }
          <div className="embed-responsive embed-responsive-21by9">
            <iframe
                title     = "Execution Monitoring"
                onLoad    = { this.iframeLoaded }
                className = "embed-responsive-item"
                src       = { this.state.href }
            />
          </div>
        </div>
        ;
    }
    return <div id="page-wrap"> { show } </div>;
  }

}

// let ExecutionMonitoring = withRouter( _ExecutionMonitoring );
export default withStyles( styles )( ExecutionMonitoring );
