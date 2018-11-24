import * as React from 'react';
import { View } from 'react-native';

import Button from 'components/button';

import firebase from 'react-native-firebase';
import ShareExtension from 'react-native-share-extension';
import s from './ShareExtension.css';

export default class ShareExtensionScreen extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.state = {
      type: '',
      value: '',
    };
  }

  static get options() {
    return {
      topBar: {
        title: {
          text: 'ShareExtension',
        },
      },
    };
  }

  componentDidAppear() {
    // console.log('componentDidAppear');

  }

  async componentDidMount() {
    // console.log('componentDidMount');

    try {
      const { type, value } = await ShareExtension.data();
      this.setState({
        type,
        value,
      });
      // console.log(type);
      // console.log(value);
    } catch (e) {
      // console.error(e);
    }
  }

  render() {
    // console.log('render');
    // console.log(this.state);
    // console.log(firebase);

    return (
      <View
        style={s.host}
      >
          <Button
            title={this.state.type}
            onPress={() => ShareExtension.close()}
          />
          <Button
            title={this.state.value}
            onPress={() => ShareExtension.close()}
          />
      </View>
      // <View style={s.host}>
      //     <View style={s.widthContainer}>
      //         <View style={s.box}></View>
      //     </View>
      // </View>
    );
  }
}
