import React from 'react';
// import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Drawer from '@material-ui/core/Drawer';
// import Button from '@material-ui/core/Button';
import IconButton from '@material-ui/core/IconButton';
import MenuIcon from '@material-ui/icons/Menu';
import List from '@material-ui/core/List';
import Typography from '@material-ui/core/Typography';
import ListItemLink from './ListItemLink';

const styles = {
  sasBlueBackground: {
    backgroundColor: '#0378CD',
  },
  fullHeight: {
    height: '100vh',
  },
  grow: {
    flexGrow: 1,
  },
};


class Header extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      left:     false,
      title:    props.title,
      leftMenu: props.menu
    };
  }

  componentWillReceiveProps (newProps) {
    this.setState({ leftMenu: newProps.menu })
  }

  _toggleDrawer = (s) => () => {
    // debugger;
    this.setState({left:s});
  };

  render () {
    const { classes } = this.props;
    // debugger;
    let leftItems = this.state.leftMenu.map((m,key) => {
      return (
        <ListItemLink
          to      = {m.path}
          primary = {m.text}
          icon    = {null}
          key     = {key.toString()}
        />
      )
    })

    let leftList = (
      <div> <List> {leftItems} </List> </div>
    )

    // debugger;
    // <Button color="inherit">Logout</Button>

    return (
      <div>
        <AppBar position="static" style={styles.sasBlueBackground}>
          <Toolbar>
            <IconButton
              color     = "inherit"
              onClick   = {this._toggleDrawer(true)}>
              <MenuIcon />
            </IconButton>
            <Typography
              variant   = "h6"
              color     = "inherit"
              style     = {styles.grow}
            >
              {this.state.title}
            </Typography>
          </Toolbar>
        </AppBar>
        <Drawer
          open    = {this.state.left}
          onClose = {this._toggleDrawer(false)}
          classes = {{paper:classes.sasBlueBackground}}
        >
        <div
            style     = {styles.sasBlueBackground}
            role      = "button"
            onClick   = {this._toggleDrawer(false)}
            onKeyDown = {this._toggleDrawer(false)}
        >
          {leftList}
        </div>
        </Drawer>
      </div>
    );
  }
}

/*
Dashboard.propTypes = {
  classes: PropTypes.object.isRequired,
};
*/

// export default Header;
export default withStyles(styles)(Header);
