import java.security.SecureRandom;

import edu.biu.scapi.comm.Channel;
import edu.biu.scapi.interactiveMidProtocols.ot.otBatch.OTBatchSInput;
import edu.biu.scapi.interactiveMidProtocols.ot.otBatch.otExtension.OTExtensionGeneralSInput;
import edu.biu.scapi.interactiveMidProtocols.ot.otBatch.otExtension.OTExtensionMaliciousSender;


public class SenderMain {
	public static void main(String[] args) {
		int m = 700;
		OTExtensionMaliciousSender sender = new OTExtensionMaliciousSender("127.0.0.1", 7766, m);
		
		Channel channel = null;
		
		byte[] x0Arr = buildRandomInput(m, 128);
		byte[] x1Arr = buildRandomInput(m, 128);
		
		OTBatchSInput input = new OTExtensionGeneralSInput(x0Arr, x1Arr, m);
		sender.transfer(channel, input);
	}

	private static byte[] buildRandomInput(int m, int bitlength) {
		SecureRandom random = new SecureRandom();
		byte[] input = new byte[m * bitlength];
		for (int i = 0; i < input.length; i++) {
			input[i] = (byte) random.nextInt(2);
		}
		return input;
	}
}
