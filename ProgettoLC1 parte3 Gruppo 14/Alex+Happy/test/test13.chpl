proc intentsProc( inarg, const outarg, val inoutarg, ref refarg ){
	  writeString( "Inside Before: ", (inarg, outarg, inoutarg, refarg) );
	    inarg = inarg + 100;
	      outarg = outarg + 100;
	        inoutarg = inoutarg + 100;
		  refarg = refarg + 100;
		    writeln( "Inside After: ", (inarg, outarg, inoutarg, refarg) );
}

