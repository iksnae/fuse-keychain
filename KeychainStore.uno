using Uno;
using Uno.Collections;
using Fuse;
using Fuse.Scripting;

using Uno.Compiler.ExportTargetInterop;

[Require("Source.Include", "Security/Security.h")]
public class KeychainStore:NativeModule
{
  public KeychainStore()
  {
    AddMember(new NativeFunction("getUserKey", fetchUserKey));
  }

  string fetchUserKey(Context c, object[] args)
  {
    return FetchUserKey();
  }

  [Foreign(Language.ObjC)]
  public static extern(iOS) string FetchUserKey()
  @{
    NSString *account = @"com.my.useridentifier";
    NSString *service = @"com.myapp";
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    keychainItem[(__bridge id)kSecAttrService] = service;
    keychainItem[(__bridge id)kSecAttrAccount] = account;
    keychainItem[(__bridge id)kSecAttrSynchronizable] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainItem[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    CFDataRef result = nil;
    OSStatus sts = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
    NSLog(@"Fetch Error Code: %d", (int)sts);
    if(sts == noErr)
    {
        NSLog(@"Identity Found!");
        NSData *resultData = (__bridge_transfer NSData *)result;
        NSString *password = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        return password;
    }else{
        NSLog(@"Identity NOT Found! Create one.");
        NSString *pw = [[NSUUID UUID]UUIDString];
        NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
        keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
        keychainItem[(__bridge id)kSecAttrService] = service;
        keychainItem[(__bridge id)kSecAttrAccount] = account;
        keychainItem[(__bridge id)kSecAttrSynchronizable] = (__bridge id)kCFBooleanTrue;
        keychainItem[(__bridge id)kSecValueData] = [pw dataUsingEncoding:NSUTF8StringEncoding];
        OSStatus sts = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
        return pw;
    }
  @}


  public static extern(!iOS) string FetchUserKey()
  {
    return "Hello Fuse!";
  }
}
