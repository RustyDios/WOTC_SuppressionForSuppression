//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_WOTC_SuppressionForSuppression.uc                                    
//           
//	File created by RustyDios	17/02/21	20:20	
//	LAST UPDATED				17/02/21	23:10
//
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_WOTC_SuppressionForSuppression extends X2DownloadableContentInfo;

var config array<name> SuppressionAbilities;
var config bool bLogThisChangeToSuppression;

static event OnLoadedSavedGame(){}

static event InstallNewCampaign(XComGameState StartState){}

static event OnPostTemplatesCreated()
{
	local X2AbilityTemplateManager	AbilityMgr;
	local X2AbilityTemplate			Template;
	local X2Condition_UnitEffects	SuppressedCondition;
	local int i;

	//KAREN !! Get the (template) managers !!
	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	//loop through the suppresion abilities
	for (i = 0 ; i < default.SuppressionAbilities.length ; i++)
	{
		Template = AbilityMgr.FindAbilityTemplate(default.SuppressionAbilities[i]);
		if (Template != none)
		{
			//add a cannot do if suppressed condition
			SuppressedCondition = new class'X2Condition_UnitEffects';
			SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
			SuppressedCondition.AddExcludeEffect('LW2WotC_AreaSuppression', 'AA_UnitIsSuppressed');
			SuppressedCondition.AddExcludeEffect('AreaSuppression', 'AA_UnitIsSuppressed');
				//SuppressedCondition.AddExcludeEffect(class'X2Effect_LW2WotC_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
				//SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
			Template.AbilityShooterConditions.AddItem(SuppressedCondition);

			`LOG("Ability patched to be unusable under suppression ::" @default.SuppressionAbilities[i], default.bLogThisChangeToSuppression, 'Rusty_SupForSup');
		}
	}
}
