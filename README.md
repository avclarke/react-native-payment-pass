# react-native-payment-pass (WIP)

## Prerequisites

To use this library you will need to be approved for the in-app provisioning entitlements from Apple and Google.

## Getting started

`$ npm install react-native-payment-pass --save` (Coming soon)

### Mostly automatic installation

### >= 0.60

Autolinking will just do the job.

### < 0.60

`$ react-native link react-native-payment-pass`

### Manual installation

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-payment-pass` and add `RNPaymentPass.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNPaymentPass.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`

- Add `import com.reactlibrary.RNPaymentPassPackage;` to the imports at the top of the file
- Add `new RNPaymentPassPackage()` to the list returned by the `getPackages()` method

2. Append the following lines to `android/settings.gradle`:
   ```
   include ':react-native-payment-pass'
   project(':react-native-payment-pass').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-payment-pass/android')
   ```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
   ```
     compile project(':react-native-payment-pass')
   ```

## Usage

```javascript
import RNPaymentPass from 'react-native-payment-pass'

try {
  const canAddPass = await RNPaymentPass.canAddPaymentPass()
  if (canAddPass) {
    RNPaymentPass.addPaymentPass('Joe Smith', '1234')
  }
} catch (error) {
  console.log(error)
}
```
