public class CampaignButtons {
	
	public String successText{ get; set; }
	
	public Campaign currentCampaign;
	public CampaignButtons(ApexPages.StandardController stdController)
	{
		currentCampaign = (Campaign)stdController.getRecord();
	}
	
	public void createRecords()
	{
		list<BH_Emails_Sent__c> emailsSentInsert = new list<BH_Emails_Sent__c>{};
		 
		// Create bh emails sent for each campaign member
		for(CampaignMember cm : queryCampaignMembers(currentCampaign.Id))
		{
			BH_Emails_Sent__c emailsSent = new BH_Emails_Sent__c();
			emailsSent.Campaign__c = cm.CampaignId;
			emailsSent.Individual__c = cm.ContactId;
			emailsSent.Date_Sent__c = cm.Date_Sent__c;
			
			emailsSentInsert.add(emailsSent);
		}
		insert emailsSentInsert;
		
		successText = 'BH emails sent created';
	}
	
	public void deleteRecords()
	{
		list<CampaignMember> cmList = queryCampaignMembers(currentCampaign.Id);
		delete cmList;
		
		successText = 'Campaign members deleted';
	}
	
	public list<CampaignMember> queryCampaignMembers(String campaignId)
	{
		return [select Id, CampaignId, ContactId, Date_Sent__c from CampaignMember where CampaignId=:campaignId];
	}
}