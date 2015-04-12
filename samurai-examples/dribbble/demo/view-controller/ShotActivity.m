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

#import "ShotActivity.h"

#pragma mark -

@implementation ShotActivity
{
	RefreshCollectionView *	_list;
}

@def_prop_strong( SHOT *,					shot );
@def_prop_strong( ShotCommentListModel *,	listModel );

- (void)onCreate
{
//	self.navigationBarTitle = [UIImage imageNamed:@"dribbble-logo.png"];
	
	self.shot = [self.intent.input objectForKey:@"shot"];
	
	self.listModel = [ShotCommentListModel new];
	self.listModel.shot_id = self.shot.id;
	[self.listModel addSignalResponder:self];
	[self.listModel modelLoad];

	[self loadViewTemplate:@"/www/html/dribbble-shot.html"];
//	[self loadViewTemplate:@"http://localhost:8000/html/dribbble-shot.html"];
}

- (void)onDestroy
{
	[self.listModel modelSave];
	[self.listModel removeSignalResponder:self];
	self.listModel = nil;
	
	[self unloadViewTemplate];
}

- (void)onStart
{
}
 
- (void)onResume
{
}

- (void)onPause
{
}

- (void)onStop
{
}

- (void)onLayout
{
	[self relayout];
}

#pragma mark -

- (void)onBackPressed
{
	
}

- (void)onDonePressed
{
}

#pragma mark -

- (void)onTemplateLoading
{
}

- (void)onTemplateLoaded
{
	[self refresh];
	[self reloadData];
}

- (void)onTemplateFailed
{
	
}

- (void)onTemplateCancelled
{
	
}

#pragma mark -

- (void)refresh
{
	[self.listModel refresh];
}

- (void)loadMore
{
	if ( [self.listModel more] )
	{
		[self.listModel loadMore];
	}
	else
	{
		[_list stopLoading];
	}
}

- (void)reloadData
{
	self[@"shot"] = @{
					  
		@"author" : @{
			@"avatar" : self.shot.user.avatar_url ?: @"", // @"https://d13yacurqjgara.cloudfront.net/users/162360/avatars/normal/logo.png?1402322917",
            @"title" : self.shot.title ?: @"", // @"Product Homepage",
			@"name" : self.shot.user.name ?: @"", // @"Unity"
		},

		@"shot" : @{
			@"img" : self.shot.images.normal ?: @"", // @"https://d13yacurqjgara.cloudfront.net/users/162360/screenshots/1914272/home_dribbble.png"
		},

		@"attr" : @{
			@"views" : @(self.shot.views_count), // @"6770",
			@"comments" : @(self.shot.comments_count), // @"19",
			@"likes" : @(self.shot.likes_count), // @"591"
		},

		@"comments" : ({
		  
			NSMutableArray * comments = [NSMutableArray array];

			for ( COMMENT * comment in self.listModel.comments )
			{
				[comments addObject:@{
					@"avatar" : comment.user.avatar_url, // @"https://d13yacurqjgara.cloudfront.net/users/162360/avatars/normal/logo.png?1402322917",
					@"name" : comment.user.name, // @"Eddy Gann",
					@"text" : comment.body, // @"Just a suggestion for a feature that means a lot to me: In-app web browser (so we can add the shot to buckets and like it.) Just adding a button to show it as it would appear in a mobile browser so we have access to the like button."
				}];
			}

			comments;
		})
	};
}

#pragma mark -

handleSignal( view_profile )
{
	[self openURL:@"/player" params:@{ @"player" : self.shot.user }];
}

handleSignal( view_comments )
{
	COMMENT * comment = [self.listModel.comments objectAtIndex:signal.sourceIndexPath.row];
	
	[self openURL:@"/player" params:@{ @"player" : comment.user }];
}

handleSignal( view_photo )
{
	[self openURL:@"/photo" params:@{ @"shot" : self.shot }];
}

#pragma mark -

handleSignal( RefreshCollectionView, eventPullToRefresh )
{
	[self refresh];
}

handleSignal( RefreshCollectionView, eventLoadMore )
{
	[self loadMore];
}

#pragma mark -

handleSignal( ShotModel, eventLoading )
{
}

handleSignal( ShotModel, eventLoaded )
{
	[_list stopLoading];
	
	[self reloadData];
}

handleSignal( ShotModel, eventError )
{
	[_list stopLoading];
}

#pragma mark -

handleSignal( ShotCommentListModel, eventLoading )
{
}

handleSignal( ShotCommentListModel, eventLoaded )
{
	[_list stopLoading];
	
	[self reloadData];
}

handleSignal( ShotCommentListModel, eventError )
{
	[_list stopLoading];
}

@end
