package net.floodlightcontroller.snort;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;

import net.floodlightcontroller.core.module.FloodlightModuleContext;
import net.floodlightcontroller.core.module.FloodlightModuleException;
import net.floodlightcontroller.core.module.IFloodlightModule;
import net.floodlightcontroller.core.module.IFloodlightService;
import net.floodlightcontroller.firewall.FirewallRule;
import net.floodlightcontroller.firewall.IFirewallService;
import net.floodlightcontroller.firewall.FirewallRule.FirewallAction;
import net.floodlightcontroller.restserver.IRestApiService;
import net.floodlightcontroller.snort.web.SnortWebRoutable;

public class Snort implements IFloodlightModule{

	// Modules this module depends on
	protected IFirewallService firewall;// Need to add firewall rules
	protected IRestApiService restApi;// Need to provide RESTful API externally
	
	// This module does not provide external services, you do not need to fill in the services provided by this module
	@Override
	public Collection<Class<? extends IFloodlightService>> getModuleServices() {
		return null;
	}

	// This module does not provide external services, so it does not implement any service interface, no need to fill in
	@Override
	public Map<Class<? extends IFloodlightService>, IFloodlightService> getServiceImpls() {
		return null;
	}

	// Fill in the dependent modules
	@Override
	public Collection<Class<? extends IFloodlightService>> getModuleDependencies() {
		Collection<Class<? extends IFloodlightService>> l = new ArrayList<>();
		l.add(IFirewallService.class);
		l.add(IRestApiService.class);
		return l;
	}

	// Initialize dependent modules through context
	@Override
	public void init(FloodlightModuleContext context) throws FloodlightModuleException {
		firewall = context.getServiceImpl(IFirewallService.class);
		restApi = context.getServiceImpl(IRestApiService.class);
	}

	@Override
	public void startUp(FloodlightModuleContext context) throws FloodlightModuleException {
		// Register the RESTful API of this module
		restApi.addRestletRoutable(new SnortWebRoutable());
		// open firewall module
		if(!firewall.isEnabled()){
			firewall.enableFirewall(true);
			// add a rule to allow pass
			FirewallRule rule = new FirewallRule();
			rule.priority=2;
			rule.action = FirewallAction.ALLOW;
			rule.ruleid=rule.genID();
			firewall.addRule(rule);
		}
		// If socket communication is used, add the following code
//		SnortThread snortThread = new SnortThread(firewall);
//		snortThread.start();
	}

}
