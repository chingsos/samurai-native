//
//     ____    _                        __     _      _____
//    / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \
//    \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/
//  /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_
//  \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/
//
//	Copyright Samurai development team and other contributors
//
//	http://www.samurai-framework.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "Samurai_Core.h"
#import "Samurai_Event.h"
#import "Samurai_UIConfig.h"

#import "Samurai_ViewCore.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@interface SamuraiUITableViewSection : NSObject

@prop_unsafe( UITableView *,		owner );
@prop_assign( NSUInteger,			index );
@prop_strong( SamuraiDocument *,	document );

- (CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSUInteger)getRowCount;
- (NSObject *)getDataForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)getCellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)clearCache;

@end

#pragma mark -

@interface SamuraiUITableViewAgent : NSObject<UITableViewDelegate, UITableViewDataSource>

@prop_unsafe( UITableView *,		owner );
@prop_strong( NSMutableArray *,		sections );

- (void)constructSections:(SamuraiRenderObject *)renderObject;

@end

#pragma mark -

@interface UITableView(Samurai)

@signal( eventWillSelectRow );
@signal( eventWillDeselectRow );

@signal( eventDidSelectRow );
@signal( eventDidDeselectRow );

- (SamuraiUITableViewAgent *)tableViewAgent;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
