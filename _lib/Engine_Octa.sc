// CroneEngine_Octa

Engine_Octa : CroneEngine {
	var <synth1, <synth2, <synth3, <synth4, <synth5, <synth6, <synth7, <synth8;

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc {
		synth1 = {
			arg out, hz1=220, amp1=0.0, type1=0, cemitone=0, amplag=0.02, hzlag=0.01;
			var amp_, hz_, waveSelect;
			waveSelect = { arg a, b;
    	  		switch(a,
    			  1, {SinOsc.ar(b);}, 2, {Saw.ar(b);},
    			  3, {Pulse.ar(b);}, 4, {Blip.ar(b);},
    			  0, {SinOsc.ar(1000);}
    			);
    		};
    	// task: change wave type
			amp_ = Lag.ar(K2A.ar(amp1), amplag);
			hz_ = Lag.ar(K2A.ar(hz1+cemitone), hzlag);
			Out.ar(out, (waveSelect.value(1, hz_) * amp_).dup);
		}.play(args: [\out, context.out_b], target: context.xg);

		synth2 = {
			arg out, hz2=220, amp2=0.0, cemitone=0, amplag=0.02, hzlag=0.01;
			var amp_, hz_;
			amp_ = Lag.ar(K2A.ar(amp2), amplag);
			hz_ = Lag.ar(K2A.ar(hz2+cemitone), hzlag);
			Out.ar(out, (SinOsc.ar(hz_) * amp_).dup);
		}.play(args: [\out, context.out_b], target: context.xg);

		synth3 = {
			arg out, hz3=220, amp3=0.0, cemitone=0, amplag=0.02, hzlag=0.01;
			var amp_, hz_;
			amp_ = Lag.ar(K2A.ar(amp3), amplag);
			hz_ = Lag.ar(K2A.ar(hz3+cemitone), hzlag);
			Out.ar(out, (SinOsc.ar(hz_) * amp_).dup);
		}.play(args: [\out, context.out_b], target: context.xg);

		synth4 = {
			arg out, hz4=220, amp4=0.0, cemitone=0, amplag=0.02, hzlag=0.01;
			var amp_, hz_;
			amp_ = Lag.ar(K2A.ar(amp4), amplag);
			hz_ = Lag.ar(K2A.ar(hz4+cemitone), hzlag);
			Out.ar(out, (SinOsc.ar(hz_) * amp_).dup);
		}.play(args: [\out, context.out_b], target: context.xg);

		synth5 = {
			arg out, hz5=220, amp5=0.0, cemitone=0, amplag=0.02, hzlag=0.01;
			var amp_, hz_;
			amp_ = Lag.ar(K2A.ar(amp5), amplag);
			hz_ = Lag.ar(K2A.ar(hz5+cemitone), hzlag);
			Out.ar(out, (SinOsc.ar(hz_) * amp_).dup);
		}.play(args: [\out, context.out_b], target: context.xg);

		synth6 = {
			arg out, hz6=220, amp6=0.0, cemitone=0, amplag=0.02, hzlag=0.01;
			var amp_, hz_;
			amp_ = Lag.ar(K2A.ar(amp6), amplag);
			hz_ = Lag.ar(K2A.ar(hz6+cemitone), hzlag);
			Out.ar(out, (SinOsc.ar(hz_) * amp_).dup);
		}.play(args: [\out, context.out_b], target: context.xg);

		synth7 = {
			arg out, hz7=220, amp7=0.0, cemitone=0, amplag=0.02, hzlag=0.01;
			var amp_, hz_;
			amp_ = Lag.ar(K2A.ar(amp7), amplag);
			hz_ = Lag.ar(K2A.ar(hz7+cemitone), hzlag);
			Out.ar(out, (SinOsc.ar(hz_) * amp_).dup);
		}.play(args: [\out, context.out_b], target: context.xg);

    synth8 = {
			arg out, hz8=220, amp8=0.0, cemitone=0, amplag=0.02, hzlag=0.01;
			var amp_, hz_;
			amp_ = Lag.ar(K2A.ar(amp8), amplag);
			hz_ = Lag.ar(K2A.ar(hz8+cemitone), hzlag);
			Out.ar(out, (SinOsc.ar(hz_) * amp_).dup);
		}.play(args: [\out, context.out_b], target: context.xg);

    this.addCommand("cemitone", "f", { arg msg;
			synth1.set(\cemitone, msg[1]);
			synth2.set(\cemitone, msg[1]);
			synth3.set(\cemitone, msg[1]);
      		synth4.set(\cemitone, msg[1]);
			synth5.set(\cemitone, msg[1]);
			synth6.set(\cemitone, msg[1]);
			synth7.set(\cemitone, msg[1]);
			synth8.set(\cemitone, msg[1]);
		});

		this.addCommand("osc1_hz", "f", { arg msg;
			synth1.set(\hz1, msg[1]);
		});

		this.addCommand("osc1_amp", "f", { arg msg;
			synth1.set(\amp1, msg[1]);
		});

		this.addCommand("osc1_type", "f", { arg msg;
			synth1.set(\type1, msg[1]);
		});

		this.addCommand("osc2_hz", "f", { arg msg;
			synth2.set(\hz2, msg[1]);
		});

		this.addCommand("osc2_amp", "f", { arg msg;
			synth2.set(\amp2, msg[1]);
		});

		this.addCommand("osc3_hz", "f", { arg msg;
			synth3.set(\hz3, msg[1]);
		});

		this.addCommand("osc3_amp", "f", { arg msg;
			synth3.set(\amp3, msg[1]);
		});

		this.addCommand("osc4_hz", "f", { arg msg;
			synth4.set(\hz4, msg[1]);
		});

		this.addCommand("osc4_amp", "f", { arg msg;
			synth4.set(\amp4, msg[1]);
		});

		this.addCommand("osc5_hz", "f", { arg msg;
			synth5.set(\hz5, msg[1]);
		});

		this.addCommand("osc5_amp", "f", { arg msg;
			synth5.set(\amp5, msg[1]);
		});

		this.addCommand("osc6_hz", "f", { arg msg;
			synth6.set(\hz6, msg[1]);
		});

		this.addCommand("osc6_amp", "f", { arg msg;
			synth6.set(\amp6, msg[1]);
		});

		this.addCommand("osc7_hz", "f", { arg msg;
			synth7.set(\hz7, msg[1]);
		});

		this.addCommand("osc7_amp", "f", { arg msg;
			synth7.set(\amp7, msg[1]);
		});

		this.addCommand("osc8_hz", "f", { arg msg;
			synth8.set(\hz8, msg[1]);
		});

		this.addCommand("osc8_amp", "f", { arg msg;
			synth8.set(\amp8, msg[1]);
		});
	}

	free {
		synth1.free;
		synth2.free;
		synth3.free;
		synth4.free;
		synth5.free;
		synth6.free;
		synth7.free;
		synth8.free;
	}

}
