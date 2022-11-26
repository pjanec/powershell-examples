//css_ref System.Runtime
//css_ref System.ObjectModel
//css_ref System.Web.Extensions
//css_ref System.Xml
//css_ref System.Core
//css_ref System.Linq
//css_ref WindowsBase
//css_ref ../bin/log4net
//css_ref ../bin/Scriban
//css_ref ../bin/Newtonsoft.Json
//css_import ../Common/ConfigDM.cs
//css_import ../Common/ConfigGenTools.cs

using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using log4net;
using Scriban;
using Scriban.Runtime;

namespace Generator
{
	public class Generator
	{
		/// <summary>
		/// Root dir of the source dist repo containing template files
		/// </summary>
		string SrcRootDir;

		/// <summary>
		/// Root dir of the destination dist repo where the generated configuration will be placed.
		/// </summary>
		string DestRootDir;

		/// <summary>
		/// Data model defining what the configuration should look like
		/// </summary>
		ConfigDM.RootObject DM;

		public Generator(string srcRootDir, string destRootDir, ConfigDM.RootObject configDM)
		{
			SrcRootDir = srcRootDir;
			DestRootDir = destRootDir;
			DM = configDM;
		}

		/*
		 * Jak na to? Zmodifikovat existujici konfiguraci v nejakem distrepu.
		 * Endpoints.lua se vygeneruje cely znove z templatu.
		 * Stejne tak Dirigent config.
		 * Jak vytvaret konfiguracni adresare pro jednotlive nody?
		 * Mit ukazkove distrepo a v nem mit templatove soubory a adresare pro urcity druh vysledneho systemu (napr. ADS)
		 * Templatove soubory a adresare drzet nejlip ve stejnem repo jako je bezici testovaci system.
		 * Pri modifikaci opatrne mazat jen soubory a adresare ktere se vygeneruji cele znovu
		 * Vytvoreni nove konfigurace
		 *   1. zkopirovat distrepo vcetne templatu (mozna jenom jeho config cast) do noveho ciloveho adresare
		 *   2. spustit generator, ktery zmodifikuje cilovy adresar
		 * Muzeme pouzit XCopy pro cilovy adresar stejny jako zdrojovy, ale musime poznat, ze zdroj a cil je stejny a resit jen template soubory a adresare.
		 * Takze:
		 *  1. Kopie zdroje. pokud je cil stejny jako zdroj, preskocime fazi XCopy celeho obsahu, jinak vytvorime cilovy adresar a podadr. strukturu a zkopirujeme soubory
		 * 	2. Generovani souboru ze sablon. Kde ve zdroji najdem sablonovy soubor mimo sablonovy adresar, vygenerujeme a prepiseme cilovy soubor. Automaticky proces.
		 * 	3. Generovani adresaru ze sablon. Kde ve zdroji najdem sablonovy adresar, spustime k nemu prirazeny powershell skript.
		 * 	4. Obecne generovani pomoci skriptu. Kdekoliv ve zdroji najdem templatovy powershell skript, spustime ho a dosadime do jeho kontextu nas datovy model.
		 * 	
		 * 	
		 * Nejak zeskriptovat i vytvareni sablonovych adresaru?
		 * 	  Mozna ke kazdemu sablonovemu adresari pridelit powershell skript, predat mu datovy model a nechat ho at udela co je treba.
		 * 	  Skript by mohl volat utility funkce z generatoru prelozeneho do assembly...
		 * 	  Cely generator jako powershell skript? Tj. i jeho master cast? Nejak mit moznost
		 * 	  
		 * Generator muze byt obecne celkem hloupy; akorat projede obsah adresare a
		 *  1. Spusti generovani souboru na zaklade templatu a datoveho modelu
		 *  2. Spusti templatove powershell skripty s datovym modelem.
		 * Templatove skripty zduplikuji adresare pro jednotlive nodyvytvori adresare apod.
		 * 
		 * Takto hloupy generator neobsahuje zadnou logiku konfigurace konkretniho systemu.
		 * Muze se tedy schovat do assembly a nechat se volat jen jako utility funkce
		 *   - prevedeni templatu podle data modelu (FileToFile)
		 *   - prevedeni templatu v celem podadresari (ale to si powershell muze udelat sam)
		 *   - spusteni vsech templatovych powershell skriptu (to si muze powershell udelat taky sam)
		 * 
		 * Cele generovani se tedy smrskne na spusteni master powershell skriptu s nainjekotvanym konfiguracnim data modelem.
		 * Veskera logika jak se co dela uz je v tomto master skriptu
		 *  - nalezeni souborovych templatu a jejich prevod na vysledne soubory
		 *  - nalezeni skriptovych templatu a jejich spusteni
		 *  
		 *  Master powershell skript si dokonce muze nacist cely json konfigurak sam prostrednictvim cs kodu pouzivajiciho newtonsoft.json!
		 */
		public void UpdateConfig(string existingInstallationRoot, ConfigDM.RootObject configDM)
		{
		}
		
		public void Generate()
		{
		}
	}



	public class Program
	{
		public class SubX
		{
			public string SubName { get; set; }
		}

		public class XXX
		{
			public string Name { get; set; }
			public SubX Sub { get; set; }
		}

		public static void MainBody()
		{
			var configDM = ConfigDM.FileUtils.ReadFromFile("test.json");
			//ConfigDM.FileUtils.WriteToFile(rootObj, "test2.json");
			configDM.CurrentEndpoint = configDM.Endpoints[0];

			//var tmplfile = "template.tmpl";
			var tmplfile = "Endpoints.lua.tmpl";
			var destFile = "Endpoints.lua";

			ConfigGen.FileUtils.RenderTemplateFileToFile(tmplfile, destFile, configDM);


			var output = System.IO.File.ReadAllText(destFile);
			Console.WriteLine(output);


			////
			//// using renamer to NOT change the identifier names
			////
			//var scriptObject1 = new ScriptObject();
			//scriptObject1.Import(model, renamer: member => member.Name);

			//var context = new TemplateContext();
			//context.PushGlobal(scriptObject1);

			//// Parse a scriban template
			//var template = Template.Parse("Hello {{Sub.SubName}}!");
			//var result = template.Render(context); // => "Hello World!"
			//Console.WriteLine(result);
		}


		[STAThread]
		public static void Main()
		{
			Console.WriteLine("Running!");

			MainBody();
		}
	}


}
