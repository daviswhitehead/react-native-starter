import './utils/setup';
import { AppRegistry } from 'react-native';

import { Navigation } from 'react-native-navigation';

import { updateTheme } from './utils/theme';
import { AppScreens, ShareExtensionScreens, startApp, startShareExtension } from './screens';
import { Store } from './store';

// Register screens
AppScreens.forEach((ScreenComponent, key) => Navigation.registerComponent(key, () => ScreenComponent));
ShareExtensionScreens.forEach((ScreenComponent, key) => Navigation.registerComponent(key, () => ScreenComponent));

// Start application
Navigation.events().registerAppLaunchedListener(() => {
  // Hydrate store and start app
  Store
    .hydrate()
    .then(updateTheme)
    .then(startApp);
});

// Start share extension
AppRegistry.registerComponent('ShareExtension', () => require('./screens/shareExtension').default);
