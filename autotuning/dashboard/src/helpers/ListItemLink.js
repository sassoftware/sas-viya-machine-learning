import React from 'react';
import ListItem from '@material-ui/core/ListItem';
import ListItemIcon from '@material-ui/core/ListItemIcon';
import ListItemText from '@material-ui/core/ListItemText';
import Typography from '@material-ui/core/Typography';
import {Link} from 'react-router-dom';


const styles = {
  textItem: {
    color: 'white',
    fontSize: '12pt',
  },
};

class ListItemLink extends React.Component {
  renderLink = (itemProps) => <Link to={this.props.to} {...itemProps} />;
  debugger;

  render() {
    const {icon, primary} = this.props;
    // debugger;
    return (
      <li>
      <ListItem button component={this.renderLink}>
        {(icon != null) ? <ListItemIcon>{icon}</ListItemIcon> : null}
        <ListItemText
          disableTypography
          primary={<Typography type="h6" style={styles.textItem}>{primary}</Typography>}
      />
      </ListItem>
      </li>
    );
  }
}
export default ListItemLink;
