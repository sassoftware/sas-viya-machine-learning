import React from "react";
import { BrowserRouter as Router, Route, Switch, Redirect} from "react-router-dom";
import Header from '../helpers/Header.js';
import ExecutionMonitoring from "./ExecutionMonitoring";
import {AppContext} from '../providers';
import "../css/styles.css";


class SideBar extends React.Component {
    static contextType = AppContext;
    constructor(props){
        super(props);
        debugger;
        this.state = { isOpen: true };
    }

    render() {
      // debugger;
      // let store = this.context;
      //Add path names and text to display on sidebar menu
      let menu = [
        {path: '/'              , text: 'Home'         , icon: null},
      ];
      debugger;
      return (
        <Router>
          <div id="App">
            <Header menu={menu} title="SAS Autotune Execution Monitoring" />
            <Switch>
                <Route exact path="/"       component={ExecutionMonitoring}  />
                <Redirect to="/"                                             />
            </Switch>
          </div>
        </Router>
      );
    }

}
export default SideBar;
// export default withAppContext(SideBar);
