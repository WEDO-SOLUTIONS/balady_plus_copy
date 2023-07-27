#import "DgisMapPlugin.h"
#if __has_include(<dgis_map/dgis_map-Swift.h>)
#import <dgis_map/dgis_map-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "dgis_map-Swift.h"
#endif

@implementation DgisMapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDgisMapPlugin registerWithRegistrar:registrar];
}
@end
