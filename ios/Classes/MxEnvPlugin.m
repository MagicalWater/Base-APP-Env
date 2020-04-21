#import "MxEnvPlugin.h"
#if __has_include(<mx_env/mx_env-Swift.h>)
#import <mx_env/mx_env-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "mx_env-Swift.h"
#endif

@implementation MxEnvPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMxEnvPlugin registerWithRegistrar:registrar];
}
@end
