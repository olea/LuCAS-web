class cuadro {
public static void main (String args[]) {
	int l ,a;
        if (args.length == 2) {
            l = Integer.valueOf(args[0]).intValue();
	    a = Integer.valueOf(args[1]).intValue();
	 }
	 else {
	  l= 20;
	  a= 15;
	 }
	  for (int i=l; i>0; i--){
	    System.out.print("*");
	    }
	    System.out.print("\n");
	    for (int i= a-2; i>0; i--){
	     System.out.print("*");
	       for(int j=l-2; j>0; j--) {
	          System.out.print(" ");
		  }
		  System.out.print("*\n");
		  }
		for (int i=l; i>0; i--){
		System.out.print("*");
		}
	      System.out.print("\n");
	   }
}



	      
