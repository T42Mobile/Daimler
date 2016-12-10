//
//  XMLConverter.h
//  Daimler
//
//  Created by Suresh on 21/06/16.
//  Copyright © 2016 benz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLConverter : NSObject

/**
 * The block called when XML-data convert finished
 * @param[in] success YES - when XML-data convert successful, otherwise - NO.
 * @param[in] dictionary Contains convert XML-data when success, otherwise - nil.
 * @param[in] error Contains error of processing XML-data if exist, otherwise - nil.
 */
typedef void (^OutputBlock)(BOOL success, NSMutableDictionary *dictionary, NSError *error);

/**
 *Convert XML data containing in input NSString object .
 *@param[in] string Contains an NSString object with XML-data in the string format.
 *@param[in] completion A block of code will be executed when the processing of XML-data is completed.
 *This parameter must not be NULL.
 */
+ (void)convertXMLString:(NSString *)string completion:(OutputBlock)completion;

/**
 *Convert XML data containing in input file.
 *@param[in] filePath Contains an NSString object with absolute path to file with XML-data.
 *@param[in] completion A block of code will be executed when the processing of XML-data is completed.
 *This parameter must not be NULL.
 */
+ (void)convertXMLFile:(NSString *)filePath completion:(OutputBlock)completion;

/**
 *Convert XML data containing in input NSData object.
 *@param[in] data Contains NSData object with encapsulated XML contents.
 *@param[in] completion A block of code will be executed when the processing of XML-data is completed.
 *This parameter must not be NULL.
 */
+ (void)convertXMLData:(NSData *)data completion:(OutputBlock)completion;

/**
 *Convert XML content referenced by the given URL.
 *@param[in] url Contains an NSURL object specifying a URL.
 *@param[in] completion A block of code will be executed when the processing of XML-data is completed.
 *This parameter must not be NULL.
 */
+ (void)convertXMLURL:(NSURL *)url completion:(OutputBlock)completion;

/**
 *Convert XML content from the specified stream.
 *@param[in] stream Contains the specified input stream in NSInputStream object.
 *@param[in] completion A block of code will be executed when the processing of XML-data is completed.
 *This parameter must not be NULL.
 */
+ (void)convertXMLStream:(NSInputStream *)stream completion:(OutputBlock)completion;

@end
