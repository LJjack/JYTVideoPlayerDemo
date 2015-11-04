//
//  CyberPlayerUtils.h
//  CyberPlayerUtils
//
//  Created by zengfanping on 6/28/13.
//  Copyright (c) 2013 mco-multimedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "p2pservice.h"

@interface CyberPlayerUtils : NSObject
/* initialize and uninitialize */


int p2pservice_init(int node_type, bool upload_to_normal_peer);

int p2pservice_destroy();

/* task management */

int p2pservice_task_create( p2p_task_param_t* param, task_handle_t* h );

int p2pservice_task_start( task_handle_t h );

int p2pservice_task_stop( task_handle_t h );

int p2pservice_task_destroy( task_handle_t h );

int p2pservice_task_info( task_handle_t h, task_info_t* inf);

int p2pservice_task_stat( task_handle_t h, p2p_task_stat_t* stat);

int p2pservice_get_redirect(task_handle_t h, TCHAR* szURL);

int p2pservice_parse_url(TCHAR* szURL, p2p_url_info_t* pInfo);

int p2pservice_set_network_status(bool bEnable);
@end
