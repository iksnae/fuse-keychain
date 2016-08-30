# fuse-keychain
A simple solution for identifying user across devices through Apple Keychain Service from fuse app. 


## Usage

``` ux
<App>
  <KeychainStore ux:Global="KeychainStore" />
  <JavaScript>
    var KeychainStore = require("KeychainStore");
    function getUserKey(){
      var k = KeychainStore.getUserKey();
      return k;
    }
    module.exports = {
      getUserKey: getUserKey()
    }
  </JavaScript>
  <Panel>
    <StackPanel>
      <Text Value="{getUserKey}"/>
    </StackPanel>
  </Panel>
</App>


```
