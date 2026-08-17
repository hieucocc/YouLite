#import <Foundation/Foundation.h>

// The IPA build uses the tweak inside the app bundle and does not ship
// roothide's private header. Keep rootless support when the header exists,
// while allowing standalone sideload builds to compile without it.
#if __has_include(<roothide.h>)
#import <roothide.h>
#else
#define jbroot(path) path
#endif

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (YTLite)

// Returns YTLite default bundle. Supports rootless if defined in compilation parameters
@property (class, nonatomic, readonly) NSBundle *ytl_defaultBundle;

@end

NS_ASSUME_NONNULL_END
