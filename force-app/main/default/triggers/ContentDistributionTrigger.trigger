trigger ContentDistributionTrigger on ContentDistribution (after update) {

	list<ID> CDs = new list<ID>();

	// did the view count change?  If so, we'll take a closer look
	for (ContentDistribution CD:trigger.new){
		if ( Trigger.newMap.get(CD.Id).ViewCount > Trigger.oldMap.get(CD.Id).ViewCount || test.isRunningTest()){
			//all we know is that it was just viewed!
			CDs.add(CD.Id);
		}
	}

	if (!System.isFuture()){
		Einstein_PlaygroundController.handleCDV(CDs);
	}

}