extern "C" {
    void ruby_sysinit(int *, char ***);
    void ruby_init(void);
    void ruby_init_loadpath(void);
    void ruby_script(const char *);
    void ruby_set_argv(int, char **);
    void rb_vm_init_compiler(void);
    void rb_vm_init_jit(void);
    void rb_vm_aot_feature_provide(const char *, void *);
    void *rb_vm_top_self(void);
    void rb_rb2oc_exc_handler(void);
    void rb_exit(int);
void MREP_B78138CD2C194AA1A5991F0A7EBCADCE(void *, void *);
void MREP_A6DB490635244DBAA4616485BCC68006(void *, void *);
void MREP_9AA0607F885B48F394A9165BE7BF125D(void *, void *);
void MREP_177B7762532D4000A409EAC3B495CB9E(void *, void *);
void MREP_146A96239CC540A880ACA91FD15690E0(void *, void *);
void MREP_8D3CE1C75FAA4D7FAC24051BF0E00B38(void *, void *);
}

extern "C"
void
RubyMotionInit(int argc, char **argv)
{
    static bool initialized = false;
    if (!initialized) {
	ruby_init();
	ruby_init_loadpath();
        if (argc > 0) {
	    const char *progname = argv[0];
	    ruby_script(progname);
	}
#if !__LP64__
	try {
#endif
	    void *self = rb_vm_top_self();
MREP_B78138CD2C194AA1A5991F0A7EBCADCE(self, 0);
MREP_A6DB490635244DBAA4616485BCC68006(self, 0);
MREP_9AA0607F885B48F394A9165BE7BF125D(self, 0);
MREP_177B7762532D4000A409EAC3B495CB9E(self, 0);
MREP_146A96239CC540A880ACA91FD15690E0(self, 0);
MREP_8D3CE1C75FAA4D7FAC24051BF0E00B38(self, 0);
#if !__LP64__
	}
	catch (...) {
	    rb_rb2oc_exc_handler();
	}
#endif
	initialized = true;
    }
}
