import { Navigation } from 'react-native-navigation';

import Home from './home';
import Counter from './counter';
import ShareExtensionScreen from './shareExtension';

export const HOME = 'ueno-rns.Home';
export const COUNTER = 'ueno-rns.Counter';
export const SHARE_EXTENSION = 'ueno-rns.ShareExtension';

export const AppScreens = new Map();
export const ShareExtensionScreens = new Map();

AppScreens.set(HOME, Home);
AppScreens.set(COUNTER, Counter);
ShareExtensionScreens.set(SHARE_EXTENSION, ShareExtensionScreen);

export const startApp = () => {
  Navigation.setRoot({
    root: {
      stack: {
        id: 'APP_ROOT_STACK',
        children: [{
          component: { name: HOME },
        }],
      },
    },
  });
};

export const startShareExtension = () => {
  Navigation.setRoot({
    root: {
      stack: {
        id: 'SHARE_ROOT_STACK',
        children: [{
          component: { name: SHARE_EXTENSION },
        }],
      },
    },
  });
};
