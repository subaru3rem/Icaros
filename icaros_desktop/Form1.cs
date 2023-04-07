using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace icaros_desktop
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            SetQrCode();

        }
        private void SetQrCode() {
            qrcode.BackgroundImage = Image.FromFile(@"qrcode.png");
        }
    }
}
