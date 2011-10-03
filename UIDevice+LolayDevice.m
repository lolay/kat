//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//

#import "UIDevice+LolayDevice.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDevice (LolayDevice)

- (NSString*) machine {
	size_t size;
	int mib[2] = {CTL_HW, HW_MACHINE};
	sysctl(mib, 2, NULL, &size, NULL, 0);
	char* machine = malloc(size);
	sysctl(mib, 2, machine, &size, NULL, 0);
	NSString* machineString = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
	free(machine);
	return machineString;
}

@end
