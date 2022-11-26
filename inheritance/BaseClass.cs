namespace PowerShellOverrideDotNetClass
{
	public class BaseClass
	{
		public virtual void VirtualMethod()
		{
			Console.WriteLine("BaseClass.VirtualMethod");
		}

		public void CallVirtualMethod()
		{
			VirtualMethod();
		}
	}
}