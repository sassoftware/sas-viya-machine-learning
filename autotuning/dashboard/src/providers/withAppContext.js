import React from 'react';
import AppContext   from './AppContext';
function withAppContext(Component) {
    return function WrapperComponent(props) {
        return (
            <AppContext.Consumer>
                {state => <Component {...props} context={state} />}
            </AppContext.Consumer>
        );
    };
}
export default withAppContext;