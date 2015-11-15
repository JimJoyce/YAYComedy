//
//  YCSettingsTableViewController.m
//  YayComedy
//
//  Created by Jim Joyce on 11/10/15.
//  Copyright © 2015 Yay Comedy. All rights reserved.
//

#import "YCSettingsTableViewController.h"

@interface YCSettingsTableViewController () <UITableViewDelegate, UITableViewDataSource> {
  NSArray *cellTitles;
  UITextView *legalText;
  UIFont *mainFont;
  UIButton *backButton;
}

@end

@implementation YCSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
  mainFont = [UIFont fontWithName:@"LoveloBlack" size:25.0f];
  cellTitles = @[@"Privacy Policy",
                 @"Terms of service",
                 @"Twitter",
                 @"Instagram"];
  [self.tableView setScrollEnabled:NO];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:4.0f/255.0f green:22.0f/255.0f blue:32.0f/255.0f alpha:1.0f];
//  [self setTransform:CGAffineTransformMakeScale(0.0f, 0.0f)];
//  [self addTableViewForSettings:frame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
  if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
  }
  
  if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellTitles.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return (CGRectGetHeight(self.tableView.frame) * .2513);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    [cell setSeparatorInset:UIEdgeInsetsZero];
  }
  
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [[UITableViewCell alloc]init];
  cell.backgroundColor = [UIColor clearColor];
  cell.textLabel.font = mainFont;
  cell.textLabel.textColor = [UIColor whiteColor];
  cell.textLabel.textAlignment = NSTextAlignmentCenter;
  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  cell.textLabel.text = [cellTitles objectAtIndex:indexPath.row];
  return cell;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *selectedCell = (UITableViewCell *)[self.tableView
                                                              cellForRowAtIndexPath:indexPath];
  selectedCell.backgroundColor = [UIColor blackColor];
  selectedCell.textLabel.textColor = [UIColor colorWithWhite:.8 alpha:1.0];
  [self parseUserSelection:indexPath.row];
}

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *selectedCell = (UITableViewCell *)[self.tableView
                                                              cellForRowAtIndexPath:indexPath];
  selectedCell.backgroundColor = [UIColor clearColor];
  selectedCell.textLabel.textColor = [UIColor whiteColor];
}


-(void)parseUserSelection:(NSUInteger)cellIndex {
  switch (cellIndex) {
    case 0:
      [self dismissTableView];
      [self addBackButton];
      [self showPrivacyPolicy];
      
      break;
    case 1:
      [self dismissTableView];
      [self addBackButton];
      [self showTerms];
      
      break;
    case 2:
      [self checkTwitterCompatibility];
      
      break;
    case 3:
      [self checkInstaCompatibility];
      
      break;
  }
}



-(void)dismissTableView {
  [UIView animateWithDuration:0.5f animations:^{
    [self.tableView.layer setAffineTransform:
     CGAffineTransformMakeTranslation(-self.tableView.frame.size.width * 2, 0)];
    self.tableView.alpha = 0;
  } completion:^(BOOL finished) {
    [self.tableView removeFromSuperview];
  }];
}

-(void)showTableView {
//  [self.tableView addSubview:self.tableView];
  
  [UIView animateWithDuration:0.5f animations:^{
    [self.tableView.layer setAffineTransform:
     CGAffineTransformMakeTranslation(0, 0)];
    self.tableView.alpha = 1.0f;
  }];
}



#pragma mark - Launch Applications

-(void)checkTwitterCompatibility {
  
  if ([[UIApplication sharedApplication] canOpenURL:
       [NSURL URLWithString:@"twitter://user?screen_name=goyaycomedy"]])
  {
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString: @"twitter://user?screen_name=goyaycomedy"]];
    
  } else
  {
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString: @"https://twitter.com/goyaycomedy"]];
  };
  
}
-(void)checkInstaCompatibility {
  
  if ([[UIApplication sharedApplication] canOpenURL:
       [NSURL URLWithString:@"instagram://user?username=goyaycomedy"]])
  {
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString: @"instagram://user?username=goyaycomedy"]];
    
  } else
  {
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString: @"https://instagram.com/goyaycomedy"]];
  };
  
}


#pragma mark - Show Labels
-(void)setUpTextFrame {
  CGRect textFrame = CGRectMake(self.tableView.frame.size.width * .1,
                                self.tableView.frame.size.height * .12,
                                self.tableView.frame.size.width * .8,
                                self.tableView.frame.size.height * .8);
  legalText = [[UITextView alloc]initWithFrame: textFrame];
  //    [legalText setUserInteractionEnabled:NO];
  [legalText setSelectable:NO];
  [legalText setBackgroundColor:[UIColor clearColor]];
  legalText.font = [UIFont fontWithName:@"LoveloBlack" size:8.0f];
  legalText.textColor = [UIColor whiteColor];
  legalText.alpha = 0;
  [legalText.layer setAffineTransform:
   CGAffineTransformMakeTranslation(self.tableView.frame.size.width, 0)];
  [self.view addSubview:legalText];
}

-(void)addBackButton {
  UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage
                                                              imageNamed:@"back_button.png"]];
  CGRect buttonFrame = CGRectMake(15.0f, 15.0f,
                                  backImage.frame.size.width,
                                  backImage.frame.size.height);
  backButton = [[UIButton alloc]initWithFrame:buttonFrame];
  [backButton setBackgroundImage:backImage.image forState:UIControlStateNormal];
  backButton.alpha = 0;
  [self.view addSubview:backButton];
  [backButton addTarget:self action:@selector(animateTextViewOut)
       forControlEvents:UIControlEventTouchUpInside];
  
}



-(void)showPrivacyPolicy {
  [self setUpTextFrame];
  legalText.text = [self privacyPolicy];
  [self animateTextViewIn];
}

-(void)showTerms {
  [self setUpTextFrame];
  legalText.text = [self termsOfUse];
  [self animateTextViewIn];
}


-(void)animateTextViewIn {
  [UIView animateWithDuration:.5 animations:^{
    [legalText.layer setAffineTransform:
     CGAffineTransformMakeTranslation(0, 0)];
    legalText.alpha = 1.0f;
    backButton.alpha = 1.0f;
  }];
}

-(void)animateTextViewOut {
  [UIView animateWithDuration:.5 animations:^{
    [legalText.layer setAffineTransform:
     CGAffineTransformMakeTranslation(self.tableView.frame.size.width, 0)];
    legalText.alpha = 0.0f;
    backButton.alpha = 0.0f;
    [self showTableView];
  } completion:^(BOOL finished) {
    [legalText removeFromSuperview];
    [backButton removeFromSuperview];
    
  }];
}



-(NSString *)termsOfUse {
  return @"\"YAY COMEDY TERMS OF SERVICE / USE (Last Updated: July 16th, 2015) \n\n The following terms and conditions (the 'Agreement') govern all use of the YAY Comedy New’s mobile application - or any name changes conducted while operating - ('Application') and the website located at yaycomedy.com (collectively with the Application and any related applications, websites, products, or services, the 'Service'). The Service is provided to you by YAY Comedy ('YAY Comedy', 'Us', 'We, or 'Our'). The Service is subject to your ('You' or 'Your') acceptance without modification of all of the terms and conditions contained herein. BY USING OR ACCESSING ANY PART OF THE SERVICE, YOU AGREE TO ALL OF THE TERMS AND CONDITIONS CONTAINED HEREIN. Special features provided by YAY Comedy may be subject to different or additional terms or conditions. To the extent they conflict with this Agreement, such different or additional terms and conditions will control. \n\nYAY Comedy reserves the right, at its sole discretion, to modify or replace any of the terms or conditions of this Agreement at any time. You will be notified of such changes by email, account notification, or a notice posted on the Service. Your continued use of the Service following the posting of any changes to this Agreement constitutes acceptance of those changes. \n\nYou hereby certify to YAY Comedy that You are at least 13 years of age. In jurisdictions where 13 is not the age of consent to contract, You represent and warrant that You have all necessary authorizations and permissions from an appropriate legal guardian. You also certify that You are otherwise legally permitted to use the Service. \n\nRESTRICTIONS. \n\n \
  You shall not, nor permit anyone else to, directly or indirectly: (i) reverse engineer, disassemble, decompile or otherwise attempt to discover the source code or underlying algorithms of all or any part of the Service (except that this restriction shall not apply to the limited extent restrictions on reverse engineering are prohibited by applicable local law); (ii) modify or create derivatives of any part of the Service; (iii) rent, lease, or use the Service for any commercial purpose; (iv) remove or obscure any proprietary notices on the Service; (v) use the Service for any unlawful purpose; (vi) access any YAY Comedy product or service not explicitly permitted by these terms; (vii) send unwanted messages or emails (i.e.,'spam') to YAY Comedy’s users; (viii) use domain names or web URLs in Your username without Our prior written consent; (ix) interfere or disrupt the Service in any way; or (x) access the Service via any automated means including without limitation scripts, bots, spiders, crawlers, or scrapers.. As between the parties, YAY Comedy shall own all title, ownership rights, and intellectual property rights in and to the Service, and any copies or portions thereof. \n\nIn the event You submit any information to the Service (such as during the registration process), You represent and warrant that You have full right and authority to do so and that such information is complete and accurate. You are responsible for all activity that occurs on Your Service account (and You must not share Your log-in details with anyone). \n\nUSER CONTENT. \n\n('User Content'). Except for the licenses You grant below, User Content submitted by You ('Your Content') is owned by You. By submitting Your Content, You grant YAY Comedy the following rights and licenses: \\nFor all Your Content, You hereby grant YAY Comedy a license to translate, modify (for technical purposes, for example making sure Your Content is viewable on mobile devices as well as a computer), reproduce and otherwise act with respect to Your Content, in each case to enable Us to operate the Service, as described in more detail below. \n\n \
  If You store Your Content in Your own personal Service account, in a manner that is not viewable by any other user except You, You grant YAY Comedy the license above, as well as a license to display, perform, and distribute Your such content for the purpose of making it accessible to You. \n\n \
  If You share Your Content only in a manner that only certain specified users can view (for example, a private text-message to one or more other users), then You grant YAY Comedy the licenses above, as well as a license to display, perform, and distribute such content for the purpose of making it accessible to such other specified users. Also, You grant such other specified users a license to access that content, and to use and exercise all rights in it, as permitted by the functionality of the Service. \n\n \
  If You share Your Content publicly via the Service and/or in a manner that more than just You or certain specified users can view, or if You provide Us (in a direct email or otherwise) with any feedback, suggestions, improvements, enhancements, and/or feature requests relating to the Service ('Feedback'), then You grant YAY Comedy the licenses above, as well as a license to display, perform, and distribute such content and Feedback for the purpose of making it accessible to all Service users, as well as all other rights necessary to use and exercise all rights in that content and Feedback in connection with the Service and/or otherwise in connection with Our business for any purpose. Also, You grant all other users of the Service a license to access such public content, and to use and exercise all rights in it, as permitted by the functionality of the Service. \n\n \
  You agree that the licenses You grant are royalty-free, perpetual, sublicenseable, irrevocable, and worldwide, provided that when You cancel Your Service account, We will stop displaying Your Content (other than Your Content that was made public available as descried above, which may remain fully available) to other users (if applicable), but You understand and agree that it may not be possible to completely delete that content from Our networks and systems, and that Your Content may remain viewable elsewhere to the extent that they were copied or stored by other users. In addition, Your Content that may be downloaded or saved by other users such as Your Content that You send in a text message to a friend may be retained by the recipient users to the extent so downloaded. \n\n \
  Finally, You understand and agree that YAY Comedy, in performing the required technical steps to provide the Service to Our users (including You), may need to make changes to Your Content to conform and adapt such content to the technical requirements of connection networks, devices, services, or media, and the foregoing licenses include the rights to do so. \n\n \
  USER CONTENT RESTRICTIONS \n\n \
  You must not submit any content that is: pornographic (or contains nudity), unlawful, offensive, threatening, racist, libelous, defamatory, obscene or otherwise objectionable or violates any third party's intellectual property rights, or rights or privacy or publicity. \n\n \
  In connection with Your Content, You affirm, represent, and warrant that (and that You can and will demonstrate to YAY Comedy’s full satisfaction upon its request that): (i) You have all necessary rights, licenses, consents and waivers to grant all of the rights and licenses You grant above, (ii) Your Content does not violate any laws or regulations, and (iii) Your Content does not infringe or otherwise violate any third party rights (including, without limitation, intellectual property rights, and the rights of publicity and privacy). \n\n \
  You are solely responsible for Your Content and the consequences of posting or publishing or sharing. You agree that YAY Comedy has no liability with respect to any of User Content, including, without limitation, Your Content, and You hereby irrevocably release YAY Comedy and its officers and directors, employees, agents, representatives and affiliates, from any and all liability arising out of or relating to any and all User Content. \n\n \
  YAY Comedy reserves the right to decide whether User Content is inappropriate or violates this Agreement. YAY Comedy may remove any User Content at any time in its discretion with or without notice. \n\n \
  GENERAL CONTENT. \n\n \
  You agree that the Service contains information and other content specifically provided by YAY Comedy or its partners and that such content is protected by copyrights, trademarks, service marks, patents, trade secrets or other proprietary rights and laws. Except as expressly authorized by YAY Comedy in writing, You shall not sell, license, rent, modify, distribute, copy, reproduce, transmit, publicly display, publicly perform, publish, adapt, edit or create derivative works from such content. However, YAY Comedy hereby grants You a limited, revocable, non- sublicensable license to reproduce and display such content (excluding any software code); provided, that You retain all copyright and other proprietary notices contained therein. Reproducing, copying or distributing any such content, including any materials or design elements on the Service, for any other purpose is strictly prohibited without the express prior written permission of YAY Comedy. \n\n \
  FEES. \n\n \
  Some products or services of the Service may require payment of fees. User shall pay all applicable fees, as described by the Service in connection with such for-fee products/services purchased by You. You agree that You alone are responsible for all data charges You incur through Your use of the Service. \n\n \
  INDEMNITY. \n\n \
  You shall indemnify and hold harmless YAY Comedy, its affiliates, its partners, and each of its, and its affiliates, and its partners, employees, contractors, directors, suppliers and representatives from all liabilities, losses, damages, claims, and expenses, including reasonable attorneys' fees, that arise from or in connection with (i) Your breach of this Agreement, or (ii) any of Your Content (including, without limitation, with respect to the violation of any third party intellectual property rights, or rights of privacy or publicity). YAY Comedy reserves the right to assume the exclusive defense and control of any matter otherwise subject to indemnification by You, in which event You will fully assist and cooperate with YAY Comedy in asserting any available defenses. \n\n \
  DISPUTES WITH OTHER USERS. \n\n \
  You are solely responsible for Your interactions with other Service users. YAY Comedy reserves the right, but has no obligation, to monitor disputes between Our users. If You have a dispute with one or more users of the Service, You shall and hereby do release YAY Comedy (and its officers, directors, agents, subsidiaries, and employees) from claims, demands and damages (actual and consequential) of every kind and nature, known and unknown, arising out of or in any way connected with such disputes. To the extent We assist in the resolution of any dispute between You and any other Service users, such assistance is only a courtesy and, therefore, You acknowledge that YAY Comedy shall not be responsible or liable for such assistance or the results thereof. \n\n \
  TERMINATION. \n\n \
  If You want to terminate this Agreement You must cancel Your Service account. You can cancel Your account by email: yaycomedy@gmail.com. YAY Comedy may terminate or suspend Your access to the Service at any time, with or without cause. Upon termination, You will no longer access (or attempt to access) the Service. All provisions of this Agreement which by their nature should survive termination shall survive termination, including, without limitation, all warranty disclaimers, limitations of liability and disputes resolutions provisions. \n\n \
  PRIVACY. \n\n ";
}

-(NSString *)privacyPolicy {
  return @"YAY Comedy takes the privacy of its users very very seriously. We strongly urge You to review our Privacy Policy. If You have any questions or concerns about how We use Your personal information  the answers should be in the policy. If not, the policy contains Our contact information so You can reach out to Us with inquiries. \n\n \
  COPYRIGHT POLICY. \n\n \
  YAY Comedy takes the protection of intellectual property rights very very seriously. If You believe that any content on the Services is infringing any copyright Your own or control, please refer to Our Copyright Policy. The policy sets out clear procedures for You to follow to request that such content be removed from the Service. \n\n \
  APPLE DEVICE TERMS. \n\n \
  In the event You are using the Application in connection with a device provided by Apple, Inc. ('Apple), the following shall apply: Both You and YAY Comedy acknowledge that this Agreement is concluded between You and YAY Comedy only, and not with Apple, and that Apple is not responsible for the Application or any content available thru the Application; You will only use the Application in connection with an Apple device that You own or control; You acknowledge and agree that Apple has no obligation whatsoever to furnish any maintenance and support services with respect to the Application; In the event of any failure of the Application to conform to any applicable warranty, including those implied by law, You may notify Apple of such failure; upon notification, Apple™s sole warranty obligation to You will be to refund to You the purchase price, if any, of the Application; You acknowledge and agree that YAY Comedy, and not Apple, is responsible for addressing any claims You or any third party may have in relation to the Application; You acknowledge and agree that, in the event of any third party claim that the Application or Your possession and use of the Application infringes that third party™s intellectual property rights, YAY Comedy, and not Apple, will be responsible for the investigation, defense, settlement and discharge of any such infringement claim; \n\n \
  You represent and warrant that You are not located in a country subject to a U.S. Government embargo, or that has been designated by the U.S. Government as a 'terrorist supporting country, and that You are not listed on any U.S. Government list of prohibited or restricted parties; \n\n \
  Both You and YAY Comedy acknowledge and agree that, in Your use of the Application, You will comply with any applicable third party terms of agreement, which may affect or be affected by such use; and \n\n \
  Both You and YAY Comedy acknowledge and agree that Apple and Apple™s subsidiaries are third party beneficiaries of this Agreement, and that upon Your acceptance of this Agreement, Apple will have the right (and will be deemed to have accepted the right) to enforce this Agreement against You as the third party beneficiary hereof. \n\n \
  DISPUTE RESOLUTION. \n\n \
  Let's Try To Work It Out. Ideally, if You have any concerns or complaints against YAY Comedy, We would like to resolve the issue without resorting to formal court or arbitration proceedings. Therefore, before filing a claim against YAY Comedy, You agree to try to resolve the dispute informally by contacting yaycomedy@gmail.com. YAY Comedy will attempt to resolve the dispute informally (and will contact You via email). If a dispute is not resolved within 16 days of submission, You may bring a formal proceeding. \n\n \
  Arbitration. Any disputes that are not settled informally shall be settled by binding arbitration in accordance with the rules and procedures of the Judicial Arbitration and Mediation Service, Inc. ('JAMS'). The arbitrator shall be selected by joint agreement between You and YAY Comedy. In the event the parties cannot agree on an arbitrator within thirty (30) days of the initiating party providing the other party with written notice that it plans to seek arbitration, the parties shall each select an arbitrator affiliated with JAMS, which arbitrators shall jointly select a third such arbitrator to resolve the dispute. The written decision of the arbitrator shall be final and binding on the parties and enforceable in any court. The arbitration proceeding shall take place in Chicago, Illinois using the English language. Notwithstanding the foregoing, either party may bring claims for equitable or injunctive relief before a court (see the 'General' section below) at any time. \n\n \
  You must include Your name and residence address, the email address You use for Your Service account, and a clear statement that You want to opt-out of this arbitration agreement. \n\n \
  No Class Actions. You may only resolve disputes with YAY Comedy on an individual basis, and may not bring a claim as a plaintiff or a class member in a class, consolidated, or representative action. Class arbitrations, class actions, private attorney general actions, and consolidation with other arbitrations aren't allowed. This paragraph will not apply to the extent prohibited by applicable law. \n\n \
  Going to Court. Subject to the arbitration provision above, You agree that the exclusive jurisdiction and venue for all disputes arising in connection with this Agreement shall be in the state and Federal courts located in Chicago, Illinois. You hereby submit to such jurisdiction and venue. \n\n \
  GENERAL. \n\n \
  The failure of either party to exercise in any respect any right provided for herein shall not be deemed a waiver of any further rights hereunder. YAY Comedy shall not be liable for any failure to perform its obligations hereunder where such failure results from any cause beyond YAY Comedy’s reasonable control, including, without limitation, mechanical, electronic or communications failure or degradation (including 'line-noise interference). If any provision of this Agreement is found to be unenforceable or invalid, that provision shall be limited or eliminated to the minimum extent necessary so that this Agreement shall otherwise remain in full force and effect and enforceable. This Agreement is not assignable, transferable or sublicensable by You except with YAY Comedy’s prior written consent. YAY Comedy may transfer, assign or delegate this Agreement and its rights and obligations without consent. This Agreement shall be governed by and construed in accordance with the laws of the state of Illinois, as if made within Illinois between two residents thereof. Both parties agree that this Agreement is the complete and exclusive statement of the mutual understanding of the parties and supersedes and cancels all previous written and oral agreements, communications and other understandings relating to the subject matter of this Agreement, and that all modifications must be in a writing signed by both parties, except as otherwise provided herein. No agency, partnership, joint venture, or employment is created as a result of this Agreement.\"";
}


@end
