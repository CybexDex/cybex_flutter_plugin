#import "CybexFlutterPlugin.h"
#import <cybex_flutter_plugin/cybex_flutter_plugin-Swift.h>

@implementation CybexFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCybexFlutterPlugin registerWithRegistrar:registrar];
}
@end
