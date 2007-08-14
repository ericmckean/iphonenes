/*

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; version 2
 of the License.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/

#import "FileBrowser.h"
#import "FileTable.h"

@implementation FileBrowser 
- (id)initWithFrame:(struct CGRect)frame{
	if ((self == [super initWithFrame: frame]) != nil) {
		UITableColumn *col = [[UITableColumn alloc]
			initWithTitle: @"FileName"
			identifier:@"filename"
			width: frame.size.width
		];

		_table = [[FileTable alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[ _table addTableColumn: col ];
		[ _table setSeparatorStyle: 1 ];
		[ _table setDelegate: self ];
		[ _table setDataSource: self ];
                if (_allowDeleteROMs == YES)
                    [ _table allowDelete: YES ];
                else
                    [ _table allowDelete: NO ];
                
		_extensions = [[NSMutableArray alloc] init];
		_files = [[NSMutableArray alloc] init];
		_rowCount = 0;

		_delegate = nil;

		[self addSubview: _table];
	}
	return self;
}

- (void)dealloc {
	[_path release];
	[_files release];
	[_extensions release];
	[_table release];
	_delegate = nil;
	[super dealloc];
}

- (NSString *)path {
	return [[_path retain] autorelease];
}

- (void)setPath: (NSString *)path {
	[_path release];
	_path = [path copy];

	[self reloadData];
}

- (void)addExtension: (NSString *)extension {
	if (![_extensions containsObject:[extension lowercaseString]]) {
		[_extensions addObject: [extension lowercaseString]];
	}
}

- (void)setExtensions: (NSArray *)extensions {
	[_extensions setArray: extensions];
}

- (void)reloadData {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath: _path] == NO) {
		return;
	}

	[_files removeAllObjects];

        NSString *file;
        NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath: _path];
	while (file = [dirEnum nextObject]) {
            char *fn = [file cStringUsingEncoding: NSASCIIStringEncoding];
            if (_saved) {
                    if (!strcasecmp(fn + (strlen(fn)-4), ".sav")) 
                        [_files addObject: file];
            } else {
                    if (!strcasecmp(fn + (strlen(fn)-4), ".nes"))
                        [_files addObject: file];
            }
        }

	//[_files sortUsingSelector:@selector(caseInsensitiveCompare:)];
	_rowCount = [_files count];
	[_table reloadData];
}

- (void)setDelegate:(id)delegate {
	_delegate = delegate;
}

- (int)numberOfRowsInTable:(UITable *)table {
	return _rowCount;
}

- (UIDeletableCell *)table:(UITable *)table cellForRow:(int)row column:(UITableColumn *)col {
	UIDeletableCell *cell = [[UIDeletableCell alloc] init];

        UITextLabel *descriptionLabel = [[UITextLabel alloc] 
            initWithFrame:CGRectMake(5.0f, 3.0f, 210.0f, 40.0f)];

        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        float whiteComponents[4] = {1, 1, 1, 1};
        float transparentComponents[4] = {0, 0, 0, 0};

        [ descriptionLabel setText:[[_files objectAtIndex: row] stringByDeletingPathExtension ]];
        [ descriptionLabel setWrapsText: YES ];
        [ descriptionLabel setBackgroundColor:CGColorCreate(colorSpace, transparentComponents) ];

        [ cell addSubview: descriptionLabel ];
        [ cell setTable: _table ];
        [ cell setFiles: _files ];
        [ cell setPath: _path ];

	return cell;
}

- (void)tableRowSelected:(NSNotification *)notification {
	if( [_delegate respondsToSelector:@selector( fileBrowser:fileSelected: )] )
		[_delegate fileBrowser:self fileSelected:[self selectedFile]];
}

- (NSString *)selectedFile {
	if ([_table selectedRow] == -1)
		return nil;

	return [_path stringByAppendingPathComponent: [_files objectAtIndex: [_table selectedRow]]];
}

- (void)setSaved:(BOOL)saved {
    _saved = saved;
    if (_allowDeleteROMs == NO)
        [ _table allowDelete: saved ];
}

- (BOOL)getSaved {
    return _saved;
}

- (void)setAllowDeleteROMs: (BOOL)allow {
    _allowDeleteROMs = allow;
    [ _table allowDelete: allow ];
}

@end
